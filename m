From: Andi Kleen <andi@halobates.de>
Subject: Re: status of MMP?
Date: Fri, 07 May 2010 17:06:53 +0200
Message-ID: <87zl0b21ki.fsf@basil.nowhere.org>
References: <201005052330.49491.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Bernd Schubert <bschubert@ddn.com>
To: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:54382 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab0EGPHA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 May 2010 11:07:00 -0400
In-Reply-To: <201005052330.49491.bs_lists@aakef.fastmail.fm> (Bernd Schubert's message of "Wed, 5 May 2010 23:30:49 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bernd Schubert <bs_lists@aakef.fastmail.fm> writes:

>
> Lustres ldiskfs already has MMP support for several years and I would like to 
> know what is the blocker for ext4? Updating the MMP patches for ext4-git 
> should be fairly simple.

AFAIK simply nobody has done the work and submitted it.

Simply adding it would break LVM snapshots though, so there's a 
compatibility issue.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
