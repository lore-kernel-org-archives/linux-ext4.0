From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] ext4-locality-groups patch
Date: Wed, 13 Dec 2006 14:32:42 -0700
Message-ID: <20061213213242.GY5937@schatzie.adilger.int>
References: <m3vekwtqnp.fsf@bzzz.home.net> <45800965.2080005@bull.net> <m3wt4vzxje.fsf@bzzz.home.net> <45801018.1090001@bull.net> <m3odq7zw1d.fsf@bzzz.home.net> <4580160B.1060006@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:57839 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbWLMWDk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Dec 2006 17:03:40 -0500
To: Valerie Clement <valerie.clement@bull.net>
Content-Disposition: inline
In-Reply-To: <4580160B.1060006@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Dec 13, 2006  16:02 +0100, Valerie Clement wrote:
> Alex Tomas wrote:
> >ah, it's simple. you're looking at superblock counters.
> >we don't update them every time. this was changed years
> >ago. try the same with regular ext3
>
> Yes, sorry, I didn't know that and I didn't notice that before.
> And the per-group counters are right.

It would be good, IMHO, to update the superblock counters periodically
anyways (e.g. statfs already has done the calculation).  Otherwise,
e2fsck on a mounted-but-idle system always complains about them being
incorrect.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
