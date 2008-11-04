From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH -v2 1/9] ext4: sparse fixes
Date: Tue, 4 Nov 2008 13:02:09 -0500
Message-ID: <20081104180209.GP30291@mit.edu>
References: <1225733769-23734-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:49119 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751888AbYKDSCM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2008 13:02:12 -0500
Content-Disposition: inline
In-Reply-To: <1225733769-23734-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In the next version of the patch, can you also remove the declaration
of ext4_fiemap() in fs/ext4/file.c?

Thanks!!

						- Ted
