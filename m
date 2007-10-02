From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Ext4 devel interlock meeting minutes (October 1, 2007)
Date: Tue, 02 Oct 2007 11:24:41 +0200
Message-ID: <47020E59.1070609@bull.net>
References: <47017053.9060005@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55746 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbXJBJY7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Oct 2007 05:24:59 -0400
In-Reply-To: <47017053.9060005@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Avantika Mathur wrote:
> Multiple Block Allocation:
> - Main outstanding issue is still need for better documentation of th=
e=20
> code.
> - Aneesh has marked the places that need explanation with fixme, and=20
> Alex will be adding the needed comments.  If this gets done quickly, =
we=20
> can try to push this feature to 2.6.24
> - Aneesh has asked for recommendations for a benchmark to run which w=
ill=20
> test the mballoc allocator.  Mingming suggested using dd and dbench, =
as=20
> was done in the past for basic mballoc patches.  To test the in-core=20
> preallocation, kernel untar tests.  Look at the file fragmentation af=
ter=20
> running the test.

Currently, the mballoc feature is not compatible with the uninit_groups=
=20
feature. I have just tried a simple test which failed. Isn't this a pro=
blem?

Another point that is not clear for me, is mballoc compatible with=20
delalloc now, or is there still a restriction?

   Val=E9rie
