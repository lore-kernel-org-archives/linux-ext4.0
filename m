From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Wed, 30 Jun 2010 16:27:10 -0700
Message-ID: <4C2BD2CE.1090201@zytor.com>
References: <FB78A152-53D3-4000-ABDB-9D6051ECB887@dilger.ca> <52423201-3DF9-4045-8E8B-FAA915053D56@dilger.ca> <20100630011656.18960.4255.stgit@warthog.procyon.org.uk> <26505.1277899544@redhat.com> <30875.1277939713@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>, viro@ZenIV.linux.org.uk,
	smfrench@gmail.com, jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:49924 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab0F3X2H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jun 2010 19:28:07 -0400
In-Reply-To: <30875.1277939713@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/30/2010 04:15 PM, David Howells wrote:
> 
> gcc for 32-bit platforms can handle 64-bit numbers.  gcc doesn't handle 128-bit
> numbers.
> 

gcc for 64-bit platforms does handle 128-bit numbers, but I don't think
it does on 32-bit platforms.

	-hpa
