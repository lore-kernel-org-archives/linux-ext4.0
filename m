From: supersud501 <supersud501@yahoo.de>
Subject: Re: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Wed, 09 Apr 2008 21:23:10 +0200
Message-ID: <47FD179E.5030103@yahoo.de>
References: <47FBB24D.90807@yahoo.de> <47FBBB13.7060501@redhat.com> <47FBCB44.1050500@yahoo.de> <20080408210048.GA16108@mit.edu> <47FC892C.5080000@yahoo.de> <20080409161117.GB26924@mit.edu> <47FD02A6.9090708@yahoo.de> <20080409185938.GE26924@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@MIT.EDU>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n7a.bullet.ukl.yahoo.com ([217.146.183.155]:41378 "HELO
	n7a.bullet.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758482AbYDIUSF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2008 16:18:05 -0400
In-Reply-To: <20080409185938.GE26924@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
>> Yeah, i'm getting some (~80) errors about i blocks being wrong (besides 
>> errors that a fast symlink has extents_fl set), and the error is always 
>> from the type: "i_blocks is x, should be x+8", so it always wants to add 8 
>> to the existing number. is this the mentioned miscalculation?
> 
> x+8, or x*8?  I would have expected the latter.
> 

really "x+8" - but since those are only "few" errors (~80 in opposite to 
the 1000++ i've with the patched version), they might not be related to 
my "huge_file" problem.

