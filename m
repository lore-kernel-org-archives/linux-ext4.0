From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: metadata_csum set but no space in dir leaf for checksum
Date: Sun, 14 Oct 2012 00:43:47 -0600
Message-ID: <65D4536C-0F58-4A26-A562-B665EC6CBBB2@dilger.ca>
References: <20121013050554.9442.qmail@science.horizon.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: "George Spelvin" <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:60713 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2JNGxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Oct 2012 02:53:11 -0400
In-Reply-To: <20121013050554.9442.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-10-12, at 11:05 PM, George Spelvin wrote:
> I've been getting a bunch of these messages in the syslog.
> I just ran e2fsck -D the other day as recommended, but now I'm getting
> more.
> 
> They don't look harmful, but they're annoying.
> 
> Kernel 3.6.1, 64-bit
> e2fsck 1.43-WIP (22-Sep-2012)
> Using EXT2FS Library version 1.43-WIP, 22-Sep-2012
> 
> Kernel messages:
> EXT4-fs error (device md5): ext4_dirent_csum_verify:262: inode #7282272: comm nfsd: metadata_csum set but no space in dir leaf for checksum.  Please run e2fsck -D.
> EXT4-fs error (device md5): ext4_find_entry:1217: inode #7282272: comm nfsd: checksumming directory block 0

This means there was an existing directory block that was completely full and
could not have the checksum added.  It isn't harmful, the chance of having
silent corruption in this specific block is very small.

The message itself should be quieted though, since there isn't anything to be
helped by printing it continuously.  I guess there is something missing in
e2fsck that it doesn't add a checksum to this block, however.

Cheers, Andreas





