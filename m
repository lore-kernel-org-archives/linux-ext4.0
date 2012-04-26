From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] ext4: remove ext4_dir_llseek
Date: Thu, 26 Apr 2012 13:13:35 -0500
Message-ID: <4F99904F.3040000@redhat.com>
References: <4F984F22.10203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757942Ab2DZSNg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Apr 2012 14:13:36 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q3QIDa9t016821
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 26 Apr 2012 14:13:36 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q3QIDZf3013937
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 26 Apr 2012 14:13:36 -0400
In-Reply-To: <4F984F22.10203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/25/12 2:23 PM, Eric Sandeen wrote:
> ext4_dir_llseek() was recently added as part of a patch to allow
> returning 64-bit name hashes.  However, reworking _llseek() is not
> necessary to achieve that goal.  One unfortunate side effect of the
> change is that it cut&pasted VFS code back into ext4, after Andi
> had just removed other _llseek cut&paste in ext4 by extending the
> VFS functionality.
> 
> It also re-introduced i_mutex locking in the dir llseek paths,
> un-doing the upstream (mostly) lockless llseek changes from Andi
> in this case.
> 
> Because of the above reasons, and because it introduces new
> EINVAL returns which were not there before, and because SEEK_END+offset
> behaves differently from SEEK_SET w.r.t. offset limits, and because
> it's not clear what problem this is solving, remove it for now.
> 
> (NFS only uses SEEK_SET and SEEK_CUR, so changes to SEEK_END shouldn't
> affect it.)
> 
> If & when a problematic and testable real-world use case is described,
> this can be re-fixed properly, possibly by expanding the VFS _llseek()
> functions to handle custom EOF offsets for cases such as this.

Self-NAK.  Realized this won't work for non-extent dirs, because the
generic llseek will EINVAL for hash "offsets" larger than the max_bitmap_bytes
value.  Will send something a little less drastic.

-Eric

