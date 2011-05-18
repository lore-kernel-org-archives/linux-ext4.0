From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: count hits/misses of extent cache and expose in
 sysfs.
Date: Wed, 18 May 2011 11:14:48 -0400
Message-ID: <20110518151448.GA29368@thunk.org>
References: <1305671213-7624-1-git-send-email-haldar@google.com>
 <3C42B155-FF68-4972-990D-7EC92B4AF3C1@dilger.ca>
 <BANLkTikMqWe-fghd3=FAGprrJT+cckaFXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Vivek Haldar <haldar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36222 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932851Ab1ERPOx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 11:14:53 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTikMqWe-fghd3=FAGprrJT+cckaFXA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2011 at 04:05:51PM -0700, Vivek Haldar wrote:
> 
> I wasn't looking at that issue specifically, but now that you mention
> it, I'll keep an eye out for it.

Vivek,

There's an internal Google bug that mentioned this; look at the
extent.c optimization feature request bugs that I had filed...

	 	      	      	      	   	  - Ted
