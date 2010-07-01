From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Thu, 01 Jul 2010 01:15:37 +0100
Message-ID: <8331.1277943337@redhat.com>
References: <4C2BD2CE.1090201@zytor.com> <FB78A152-53D3-4000-ABDB-9D6051ECB887@dilger.ca> <52423201-3DF9-4045-8E8B-FAA915053D56@dilger.ca> <20100630011656.18960.4255.stgit@warthog.procyon.org.uk> <26505.1277899544@redhat.com> <30875.1277939713@redhat.com>
Cc: dhowells@redhat.com, Andreas Dilger <adilger@dilger.ca>,
	viro@ZenIV.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
	mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
	sjayaraman@suse.de, linux-ext4@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab0GAAPw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jun 2010 20:15:52 -0400
In-Reply-To: <4C2BD2CE.1090201@zytor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

H. Peter Anvin <hpa@zytor.com> wrote:

> gcc for 64-bit platforms does handle 128-bit numbers, but I don't think
> it does on 32-bit platforms.

How do you specify them?  If I say "long long long" gcc moans that it can't
support it on x86_64.

David
