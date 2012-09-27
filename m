From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: ext4_bread usage audit
Date: Thu, 27 Sep 2012 15:29:39 +0200
Message-ID: <AEF10200-E1C9-4E43-81E2-7B31B144A062@dilger.ca>
References: <1348512100-23323-1-git-send-email-cmaiolino@redhat.com> <20120926034240.GE11468@thunk.org> <50627B01.6070306@redhat.com> <20120926141417.GA3485@andromeda.usersys.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:44582 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758319Ab2I1Oxc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Sep 2012 10:53:32 -0400
In-Reply-To: <20120926141417.GA3485@andromeda.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-09-26, at 4:14 PM, Carlos Maiolino wrote:
> In regards to the coding style of if conditionals, I just followed the coding
> style of most places in the code, I also changed some of the if conditionals to
> match the rest of the code. i.e.:
> 
> if(!(bh = ext4_bread())) {
> 	do_something();
> }
> 
> if you take a look at the code, most if conditionals regarding the calls to
> ext4_bread() are in the above coding style. I just followed it, but, I'm not
> against change that to another one, but agree the above looks better and save
> some code lines.

The reason that having assignments in conditionals is bad is that it allows
hard-to-find bugs to be in the code:

        if ((bh == ext4_bread())

and

        if ((bh = ext4_bread())

look very similar to the reader, but the use of extra "()" around the
assignment quiets any compiler warnings about incorrect assignments.
In this specific case you _do_ want the assignment to bh, but in many
other cases you do not:

        if (bh = NULL)

would set bh to NULL instead of comparing it, and is IMHO bad coding style.

Cheers, Andreas





