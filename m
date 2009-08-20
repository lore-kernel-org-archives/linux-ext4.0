From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: Large volume ll_ver_fs results (w/ short read/write patch).
Date: Thu, 20 Aug 2009 12:54:30 -0400
Message-ID: <9504.1250787270@alphaville.usa.hp.com>
References: <20654.1250520912@gamaville.dokosmarshall.org>  <20090820010414.GA649@webber.adilger.int>
Reply-To: nicholas.dokos@hp.com
Cc: Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:26037 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbZHTQy2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Aug 2009 12:54:28 -0400
In-Reply-To: Message from Andreas Dilger <adilger@sun.com>
   of "Wed, 19 Aug 2009 19:04:14 MDT." <20090820010414.GA649@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> Nick, thanks for the patch.  I'm incorporating the fixes upstream,
> but one question that was raised is that (in essence) this allows
> IO errors to be hit, yet and the return code from llverfs is 0.
> The llverdev/llverfs tools are used not only for finding software
> data corruption bugs, but also to verify the underlying media.
> 
> It was definitely a bug in the original code that there was no
> error reported during the write phase if there was a short write,
> but this was at least caught during the read phase because the
> data would be incorrect.
> 
> What I've done is to count errors hit during read and write, and
> then exit with a non-zero value if there were any IO errors hit
> (as happened in your case), even if the rest of the data was
> verified correctly.  This allows scanning the whole disk in a
> single pass (if there are not too many underlying errors) but
> still ensuring there is no false sense of security because the
> program exited with 0.
> 
> The current patch can be gotten at:
> 
> https://bugzilla.lustre.org/attachment.cgi?id=25407&action=edit
> 

Thanks! It looks good at first glance: I'll be trying it out before
long and will let you know if I come up against any problems.

Nick
