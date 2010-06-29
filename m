From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and i_generation available by xattrs
Date: Tue, 29 Jun 2010 23:44:37 +0100
Message-ID: <26197.1277851477@redhat.com>
References: <20100628164854.GA9979@samba1> <20100628162626.6026.26679.stgit@warthog.procyon.org.uk> <AANLkTikkaRYyUfHILDCKYzXdLi9ORuQs05Rf9TScF_Tz@mail.gmail.com>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
	viro@zeniv.linux.org.uk, jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: Jeremy Allison <jra@samba.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab0F2Wou (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jun 2010 18:44:50 -0400
In-Reply-To: <20100628164854.GA9979@samba1>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jeremy Allison <jra@samba.org> wrote:

> We already have code in Samba to detect "birthtime"
> (st_btime) as a returned member of a stat struct.

Is it, though?

Googling for st_btime suggests it could also be taken as the time last
archived.  That may just be a NetWareism though.

David
