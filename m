From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: new mballoc patches.
Date: Wed, 26 Sep 2007 22:58:21 -0700
Message-ID: <20070926225821.8cc6a2e0.akpm@linux-foundation.org>
References: <46E651E6.3070107@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	Mingming Cao <cmm@us.ibm.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55808 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145AbXI0F7O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Sep 2007 01:59:14 -0400
In-Reply-To: <46E651E6.3070107@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 11 Sep 2007 13:59:26 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> I have updated the mballoc patches.

Has anyone reviewed this stuff?  I don't see much evidence of it here?

Just a quick scan shows up heavy over-inlining, many
macros-which-should-be-functions and numerous needlessly global symbols. 
Whether there are more substantial problems in there I have not the time to
tell.
