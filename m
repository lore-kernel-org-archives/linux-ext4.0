From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] annotate superblock field offsets
Date: Mon, 29 Nov 2010 17:46:36 -0600
Message-ID: <4CF43B5C.2020909@redhat.com>
References: <bug-23772-13602@https.bugzilla.kernel.org/> <201011292155.oATLt4vX027018@demeter2.kernel.org> <7258D44F-8334-4604-90EE-019F1B33B1FC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab0K2Xqm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Nov 2010 18:46:42 -0500
In-Reply-To: <7258D44F-8334-4604-90EE-019F1B33B1FC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/29/10 5:45 PM, Andreas Dilger wrote:
> The s_mount_options field has the unfortunate distinction of being the first field beyond 0x200 in the superblock (i.e. second sector of 1kB superblock area).  
> 
> Annotate the superblock fields with offsets so that it is easier to see
> these boundaries, and decode the superblock in the future.
> 
> Cheers, Andreas
> 

thank you, I had just about done this in anger as well ;)

-Eric
