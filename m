From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] ext4-locality-groups patch
Date: Wed, 13 Dec 2006 16:26:29 -0600
Message-ID: <45807E15.3080200@redhat.com>
References: <m3vekwtqnp.fsf@bzzz.home.net> <45800965.2080005@bull.net> <m3wt4vzxje.fsf@bzzz.home.net> <458010CE.6020402@redhat.com> <20061213213338.GZ5937@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>,
	Valerie Clement <valerie.clement@bull.net>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbWLMW0f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Dec 2006 17:26:35 -0500
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20061213213338.GZ5937@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Dec 13, 2006  08:40 -0600, Eric Sandeen wrote:
>> This is probably a discrepancy that comes from reading the block device 
>> directly, right?  Which is not necessarily in sync with the address 
>> space for the filesystem.
> 
> In fact, the block device IS in sync with the filesystem address space,
> but only for metadata.  The file data each has its own address space and
> is not coherent.

Ah, thanks for the clarification.

-Eric
