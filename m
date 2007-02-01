From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fw: [BUG -mm] ext3_orphan_add() accessing corrupted list on a
 corrupted ext3fs
Date: Thu, 01 Feb 2007 10:58:08 -0600
Message-ID: <45C21C20.7080807@redhat.com>
References: <20070201010836.31a63ef2.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Fengguang Wu <fengguang.wu@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422728AbXBAQ5t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Feb 2007 11:57:49 -0500
In-Reply-To: <20070201010836.31a63ef2.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> 
> Begin forwarded message:
> 
> Date: Thu, 1 Feb 2007 16:44:39 +0800
> From: Fengguang Wu <fengguang.wu@gmail.com>
> To: LKML <linux-kernel@vger.kernel.org>
> Subject: [BUG -mm] ext3_orphan_add() accessing corrupted list on a corrupted ext3fs
> 
> 
> I accidentally ran two qemu instances on the same ext3 fs, after that bad
> things happened. After exiting the two qemus and running a new one, I got the
> following oops:

Is this equivalent to mounting the same SAN block device on 2 different
machines?  And if so how much can the filesystem really be expected to
cope with this?

(remembering to read the rest of his inbox...)

Andreas Dilger wrote:

> I don't have a comment on the actual bug here, but this is another case
> where it would be nice to have multi-mount protection built into ext3...
> When I last proposed this it was refused on the grounds that an external
> HA manager should be doing this job but I don't think that is realistic.

I'm with Andreas on this one, in the era of SANs, iscsi, virtual
machines, and suspended images, it would be nice to prevent multiple
mounts at the fs (or vfs?) level....

-Eric
