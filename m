From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] e2fsck/e2fsprogs: answer yes/no to a group of questions
Date: Wed, 1 Aug 2007 16:28:56 -0600
Message-ID: <20070801222856.GA5692@schatzie.adilger.int>
References: <f8pvvg$3uo$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Bernd Schubert <bschubert@q-leap.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:60601 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbXHBPJx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Aug 2007 11:09:53 -0400
Content-Disposition: inline
In-Reply-To: <f8pvvg$3uo$1@sea.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 01, 2007  14:57 +0200, Bernd Schubert wrote:
> saying yes or no to all e2fsck questions can be rather annoying (yes I
> know -p and -y), so here's a patch to answer yes or no to a group of
> questions.

I've wanted something like this for quite a while already.

What would be more useful, however, is having the yes-to-all or no-to-all
apply to a particular problem instead of being generic.  Otherwise it
isn't really different from using -y or -n.  The reason that is useful
is that often there is a particular problem that should all be fixed or
skipped, but you want to be prompted how to fix a different problem type.

I haven't investigated, but maybe this could be implemented in the
same way as a latch for every problem?

> +	if (ptr->flags & PR_YES_TO_ALL) {
> +		printf("%s: yes\n", _(prompt[(int) ptr->prompt]));
> +		return YES;
> +	} else if (ptr->flags & PR_NO_TO_ALL) {
> +		printf("%s: no\n", _(prompt[(int) ptr->prompt]));
> +		return NO;
> +	}

The "yes" and "no" here should be "_("yes")" and "_("no")" like in
ask() so they are translated.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
