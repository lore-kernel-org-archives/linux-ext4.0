From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 0/4] Journal guided resync and support
Date: Fri, 02 Oct 2009 02:36:33 +0200
Message-ID: <874oqitywe.fsf@basil.nowhere.org>
References: <20091001223929.120106893@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: scjody@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:53462 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbZJBAgd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2009 20:36:33 -0400
In-Reply-To: <20091001223929.120106893@sun.com> (scjody@sun.com's message of "Thu, 01 Oct 2009 18:39:29 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

scjody@sun.com writes:
>
> The changes consist of patches to ext3, jbd, MD, and the raid456 personality.
> These patches are currently against the RHEL 5 kernel 2.6.18-128.1.6.  Porting
> to ext4/jbd2 and a more modern kernel is a TODO item.

The basic idea seems very cool, but the code would probably need
porting to mainline before anything could be done with it on this
list. Also most likely you would need a ext4 version.
(my experience is that the ext3 maintainers don't accept new features
anymore)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
