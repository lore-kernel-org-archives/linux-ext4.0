From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Mon, 19 May 2008 09:26:41 -0400
Message-ID: <200805190926.41970.chris.mason@oracle.com>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <87ej7zcrqv.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jamie@shareable.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:44291 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764015AbYESN3S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 May 2008 09:29:18 -0400
In-Reply-To: <87ej7zcrqv.fsf@basil.nowhere.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sunday 18 May 2008, Andi Kleen wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> > On Fri, 16 May 2008 14:02:46 -0500
> >
> > Eric Sandeen <sandeen@redhat.com> wrote:
> >> A collection of patches to make ext3 & 4 use barriers by
> >> default, and to call blkdev_issue_flush on fsync if they
> >> are enabled.
> >
> > Last time this came up lots of workloads slowed down by 30% so I
> > dropped the patches in horror.
>
> Didn't ext4 have some new checksum trick to avoid them?

I didn't think checksumming avoided barriers completely.  Just the barrier 
before the commit block, not the barrier after.

-chris
