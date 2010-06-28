From: Jeremy Allison <jra@samba.org>
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and
	i_generation available by xattrs
Date: Mon, 28 Jun 2010 09:48:54 -0700
Message-ID: <20100628164854.GA9979@samba1>
References: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk> <AANLkTikkaRYyUfHILDCKYzXdLi9ORuQs05Rf9TScF_Tz@mail.gmail.com>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk,
	jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fn.samba.org ([216.83.154.106]:35526 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab0F1Q60 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jun 2010 12:58:26 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTikkaRYyUfHILDCKYzXdLi9ORuQs05Rf9TScF_Tz@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 28, 2010 at 11:33:10AM -0500, Steve French wrote:
> 
> It would be easy enough to do something similar for crtime for cifs
> (it may also be possible to do something similar to
> i_generation and i_version at least for smb2 but haven't
> experimented to see which servers could return something
> similar to version and generation).  I did have a request for
> someone doing a backup application over cifs to return creation
> time so at least this would make sense.

We already have code in Samba to detect "birthtime"
(st_btime) as a returned member of a stat struct.

This already works on many other platforms, so I'd
rather just have Linux stat fixed to work with
btime.

Jeremy.
