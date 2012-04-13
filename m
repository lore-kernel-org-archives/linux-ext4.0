From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bug: Large writes can fail on ext4 if the write buffer is not
 empty
Date: Fri, 13 Apr 2012 10:10:22 +1000
Message-ID: <20120413001022.GY18323@dastard>
References: <793C2320-255A-4894-AA07-70EDBB1DDDA5@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jouni Siren <jouni.siren@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:47794 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701Ab2DMAKZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Apr 2012 20:10:25 -0400
Content-Disposition: inline
In-Reply-To: <793C2320-255A-4894-AA07-70EDBB1DDDA5@iki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 12, 2012 at 05:47:41PM +0300, Jouni Siren wrote:
> Hi,
> 
> I recently ran into problems when writing large blocks of data (more than about 2 GB) with a single call, if there is already some data in the write buffer. The problem seems to be specific to ext4, or at least it does not happen when writing to nfs on the same system. Also, the problem does not happen, if the write buffer is flushed before the large write.
> 
> The following C++ program should write a total of 4294967304 bytes, but I end up with a file of size 2147483664.
> 
> #include <fstream>
> 
> int
> main(int argc, char** argv)
> {
>   std::streamsize data_size = (std::streamsize)1 << 31;
>   char* data = new char[data_size];
> 
>   std::ofstream output("test.dat", std::ios_base::binary);
>   output.write(data, 8);
>   output.write(data, data_size);
>   output.write(data, data_size);
>   output.close();
> 
>   delete[] data;
>   return 0;
> }
> 
> 
> The relevant part of strace is the following:
> 
> open("test.dat", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
> writev(3, [{"\0\0\0\0\0\0\0\0", 8}, {"", 2147483648}], 2) = -2147483640
> writev(3, [{0xffffffff80c6d258, 2147483648}, {"", 2147483648}], 2) = -1 EFAULT (Bad address)

EFAULT - your user buffer is too large.

IOWs, you can't do IO in chunks of 2GB or greater in a single buffer
or iovec. This limit is imposed by the VFS to prevent overflows in
badly implemented filesystem code.

Just do mulitple smaller IOs - it will be just as to do a single 2GB
IO....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
