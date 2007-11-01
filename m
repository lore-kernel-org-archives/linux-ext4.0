From: Coly Li <coyli@suse.de>
Subject: Re: [PATCH 13/13][e2fsprogs] Add m_uninit test case.
Date: Thu, 01 Nov 2007 17:48:49 +0800
Message-ID: <4729A101.40709@suse.de>
References: <20071011191559.4599.69332.stgit@gara> <20071011191719.4599.72320.stgit@gara>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:48548 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbXKAJrg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Nov 2007 05:47:36 -0400
In-Reply-To: <20071011191719.4599.72320.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I plan to do some work based on uninit group patch. When I try to patch the patch into kernel, I
find the sequence number of patch is not continuous. Here is what I find for e2fsprogs patch,

[PATCH 00/13]
[PATCH 02/13]
[PATCH 03/13]
[PATCH 04/13]
[PATCH 05/13]
[PATCH 06/13]
[PATCH 07/13]
[PATCH 08/13]
[PATCH 09/13]
[PATCH 10/13]
[PATCH 13/13]

I can not find 01, 11 and 12. Do I miss them, or where can I find these 3 patch ?

Thanks.


Jose R. Santos wrote:
> From: Jose R. Santos <jrs@us.ibm.com>
> 
> Add m_uninit test case.
> 
> Add test case to test for uninit block groups.
> 
> Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
> --
> 
>  tests/m_uninit/expect.1 |  166 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/m_uninit/script   |    4 +
>  2 files changed, 170 insertions(+), 0 deletions(-)
> 
-- 
Coly Li
SuSE PRC Labs
