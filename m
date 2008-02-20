From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [E2FSPROGS, RFC] New mke2fs types parsing
Date: Wed, 20 Feb 2008 12:51:21 -0600
Message-ID: <47BC76A9.307@redhat.com>
References: <E1JRpaN-0000Bs-4N@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762557AbYBTSvZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Feb 2008 13:51:25 -0500
In-Reply-To: <E1JRpaN-0000Bs-4N@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> The following patch is a work in progress, but I'm sending it out so
> folks can take a look at it and comment on the general approach.
> 
> What this does is change how mke2fs -T works so it can take a comma
> separated list, so you can do things like this:
> 
> 	  mke2fs -T ext4,small,news

Is there some hierarchy of what these options are and how they fit
together?  i.e. small & news might go together (in bizarro world...) but
"small,large" wouldn't make sense - nor would -T ext3,ext4.  Or, if
somebody stores mail & news on the same fs, nad they say -T mail,news
but the mail & news types have conflicting directives...

how will you define what an acceptable composite of subtypes will be?

Thanks,

-Eric
