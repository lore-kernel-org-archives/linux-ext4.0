From: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 4/6] Ext4: fail if we try to use hole punch
Date: Tue, 16 Nov 2010 15:07:29 +0200
Message-ID: <4CE28211.6060204@redhat.com>
References: <1289840723-3056-1-git-send-email-josef@redhat.com> <1289840723-3056-5-git-send-email-josef@redhat.com> <4CE2783F.1020004@redhat.com> <20101116125016.GA31957@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
	cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067Ab0KPNHq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Nov 2010 08:07:46 -0500
In-Reply-To: <20101116125016.GA31957@dhcp231-156.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/16/2010 02:50 PM, Josef Bacik wrote:
> On Tue, Nov 16, 2010 at 02:25:35PM +0200, Avi Kivity wrote:
> >  On 11/15/2010 07:05 PM, Josef Bacik wrote:
> >>  Ext4 doesn't have the ability to punch holes yet, so make sure we return
> >>  EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
> >>  be added later.  Thanks,
> >>
> >
> >  Instead of teaching filesystems to fail if they don't support the
> >  capability, why don't supporting filesystems say so, allowing the fail
> >  code to be in common code?
> >
>
> There is no simple way to test if a filesystem supports hole punching or not so
> the check has to be done per fs.  Thanks,

Could put a flag word in superblock_operations.  Filesystems which 
support punching (or other features) can enable it there.

Or even have its own callback.

-- 
error compiling committee.c: too many arguments to function

