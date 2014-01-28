From: Masato Minda <minmin@jprs.co.jp>
Subject: Re: How many files to create in one directory?
Date: Tue, 28 Jan 2014 11:53:08 +0900
Message-ID: <52E71B94.4000406@jprs.co.jp>
References: <52E607B1.2060206@jprs.co.jp> <52E69F3F.2000104@redhat.com> <20140127193950.GA20411@thunk.org> <52E6B80D.7060807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from off-send01.tyo.jprs.co.jp ([202.11.16.150]:54457 "EHLO
	off-send01.tyo.jprs.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaA1CxR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jan 2014 21:53:17 -0500
In-Reply-To: <52E6B80D.7060807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric-san, Ted-san;

Thank you very much. I am happy now.

On 2014/01/28 3:02, Eric Sandeen wrote:
>
> It will depend on the length of the filenames.  But by my calculations,
> for average 28-char filenames, it's closer to 30 million.
> 
> There are (4096-32)/8 indices per block, or 508.
> There are 2 levels, so 508*508=258064 leaf blocks.
> The length of each record for 28 char names would be 32 bytes.
> So you can fit 4096/32 = 128 entries per leaf block.
> 258064 leaf blocks * 128 entries/bock is 33,032,192 entries.

I understand.

> I recently made a spreadsheet to calculate this.
> I'm not sure if I am doing google docs sharing and protection
> correctly, but this might work:
> 
> https://docs.google.com/spreadsheet/ccc?key=0AtdHTZsZ8XoYdE1IUXlDb1RXQkdPM3F4YWpfNGhMbFE&usp=sharing#gid=0

Great! It is useful for us.

On 2014/01/28 4:39, Theodore Ts'o wrote:
>
> Note that there will be some very significant performance problems
> well before a directory gets that big.  For example, just simply doing
> a readdir + stat on all of the files in that directory (or a readdir +
> unlink, etc.) will very likely result in extremely unacceptable
> performance.

Of course, I know that issue. But we have already this directory.

	$ \ls -f | wc
	1933497 1933497 14968002

This is for mail archive. :-(

On 2014/01/28 4:48, Eric Sandeen wrote:
> 
> Yep, that's the max possible, not the max useable.  ;)

Yes, I wanted to know the limitation.

Again, Thank you very much.

Best Regards,

--
Masato minmin Minda <minmin@jprs.co.jp>
Japan Registry Services Co., Ltd. (JPRS)

