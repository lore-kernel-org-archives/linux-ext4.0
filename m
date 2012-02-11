From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [SOLVED] (was "Re: Restoring filenames from partly damaged ext4-filesystem")
Date: Sat, 11 Feb 2012 11:47:14 -0700
Message-ID: <63EF8E19-8A47-4372-96FD-0963F0F4D272@dilger.ca>
References: <1328804993.34330.YahooMailNeo@web132403.mail.ird.yahoo.com> <1328981610.63291.YahooMailNeo@web132402.mail.ird.yahoo.com> <20120211183006.GC13189@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Rudolf Zran <rudolfzran@yahoo.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"debian-user@lists.debian.org" <debian-user@lists.debian.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:17086 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab2BKSrS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Feb 2012 13:47:18 -0500
In-Reply-To: <20120211183006.GC13189@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-11, at 11:30 AM, Ted Ts'o wrote:
> On Sat, Feb 11, 2012 at 05:33:30PM +0000, Rudolf Zran wrote:
>> Hi List!
>> 
>> In an offlist reply someone recommended me ext4magic (see
>> http://developer.berlios.de/projects/ext4magic ).
> 
> I wasn't familiar with ext4magic, so thanks for recommending it.
> After taking a quick look at its wiki page, it looks like worthy
> successor to ext3grep (which only works on ext3 file systems).  It
> appears from their web page (I haven't had a chance to play with it
> yet) that it uses a variety of techniques to recover data, which
> combined should work really well.

Looks interesting and useful...  I wonder if it makes sense to include
this into e2fsprogs at some point, so that it is available when users
need it most...

Cheers, Andreas





