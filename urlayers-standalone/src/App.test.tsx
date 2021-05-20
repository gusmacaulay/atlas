import React from 'react';
import { render, screen } from '@testing-library/react';
import App from './App';

test('renders unconnected text', () => {
  render(<App />);
  const linkElement = screen.getByText(/Unconnected/i);
  expect(linkElement).toBeInTheDocument();
});
