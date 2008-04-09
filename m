From: supersud501 <supersud501@yahoo.de>
Subject: Re: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Wed, 09 Apr 2008 19:56:42 +0200
Message-ID: <47FD035A.7060804@yahoo.de>
References: <47FBB24D.90807@yahoo.de> <47FBBB13.7060501@redhat.com> <47FBCB44.1050500@yahoo.de> <20080408210048.GA16108@mit.edu> <47FC892C.5080000@yahoo.de> <20080409161117.GB26924@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n26.bullet.mail.ukl.yahoo.com ([87.248.110.143]:24455 "HELO
	n26.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752575AbYDISmL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2008 14:42:11 -0400
In-Reply-To: <20080409161117.GB26924@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> That patch which I just sent out passes the regression test suite, but
> it hasn't been extensively tested for actual *huge* files.
> (Specifically, files with the EXT4_HUGE_FILE_FL because they are
> larger than 2TB and so i_blocks had to be specified in units of
> filesystem blocksize, instead of units of 512 bytes.)
> 

ah ok, found it (i should read all mails before answering them :) )

