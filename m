From: Jouni Siren <jouni.siren@iki.fi>
Subject: Bug: Large writes can fail on ext4 if the write buffer is not empty
Date: Thu, 12 Apr 2012 17:47:41 +0300
Message-ID: <793C2320-255A-4894-AA07-70EDBB1DDDA5@iki.fi>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40672 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965214Ab2DLOwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Apr 2012 10:52:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I recently ran into problems when writing large blocks of data (more than about 2 GB) with a single call, if there is already some data in the write buffer. The problem seems to be specific to ext4, or at least it does not happen when writing to nfs on the same system. Also, the problem does not happen, if the write buffer is flushed before the large write.

The following C++ program should write a total of 4294967304 bytes, but I end up with a file of size 2147483664.

#include <fstream>

int
main(int argc, char** argv)
{
  std::streamsize data_size = (std::streamsize)1 << 31;
  char* data = new char[data_size];

  std::ofstream output("test.dat", std::ios_base::binary);
  output.write(data, 8);
  output.write(data, data_size);
  output.write(data, data_size);
  output.close();

  delete[] data;
  return 0;
}


The relevant part of strace is the following:

open("test.dat", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
writev(3, [{"\0\0\0\0\0\0\0\0", 8}, {"", 2147483648}], 2) = -2147483640
writev(3, [{0xffffffff80c6d258, 2147483648}, {"", 2147483648}], 2) = -1 EFAULT (Bad address)
write(3, "\0\0\0\0\0\0\0\0", 8)         = 8
close(3)                                = 0


The first two writes are combined into a single writev call that reports having written -2147483640 bytes. This is the same as 8 + 2147483648, when interpreted as a signed 32-bit integer. After the first call, everything more or less fails. This happens on a Linux system, where uname -a returns

Linux alm01 2.6.32-220.7.1.el6.x86_64 #1 SMP Tue Mar 6 15:45:33 CST 2012 x86_64 x86_64 x86_64 GNU/Linux


I believe that the bug can be found in file.c, function ext4_file_write, where variable ret has type int. Function generic_file_aio_write returns the number of bytes written as a ssize_t, and the returned value is stored in ret and eventually returned by ext4_file_write. If the number of bytes written is more than INT_MAX, the value returned by ext4_file_write will be incorrect.

If you need more information on the problem, I will be happy to provide it.

-- 
Jouni Siren - jouni.siren@iki.fi - http://iki.fi/jouni.siren/




