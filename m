From: Coly Li <coyli@suse.de>
Subject: Re: [PATCH 13/13][e2fsprogs] Add m_uninit test case.
Date: Thu, 01 Nov 2007 17:58:42 +0800
Message-ID: <4729A352.1000808@suse.de>
References: <20071011191559.4599.69332.stgit@gara> <20071011191719.4599.72320.stgit@gara> <4729A101.40709@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Jose R. Santos" <jrs@us.ibm.com>, linux-ext4@vger.kernel.org
To: coyli@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:48869 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136AbXKAJ5Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Nov 2007 05:57:25 -0400
In-Reply-To: <4729A101.40709@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Coly Li wrote:
> I plan to do some work based on uninit group patch. When I try to patch the patch into kernel, I
                                                                                   ~~~~~~~~~~~~sorry
it's typo, I mean into e2fsprogs...
> find the sequence number of patch is not continuous. Here is what I find for e2fsprogs patch,
> 
> [PATCH 00/13]
> [PATCH 02/13]
> [PATCH 03/13]
> [PATCH 04/13]
> [PATCH 05/13]
> [PATCH 06/13]
> [PATCH 07/13]
> [PATCH 08/13]
> [PATCH 09/13]
> [PATCH 10/13]
> [PATCH 13/13]
> 
> I can not find 01, 11 and 12. Do I miss them, or where can I find these 3 patch ?
> 
> Thanks.
> 
> 
> Jose R. Santos wrote:
>> From: Jose R. Santos <jrs@us.ibm.com>
>>
>> Add m_uninit test case.
>>
>> Add test case to test for uninit block groups.
>>
>> Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
>> --
>>
>>  tests/m_uninit/expect.1 |  166 +++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/m_uninit/script   |    4 +
>>  2 files changed, 170 insertions(+), 0 deletions(-)
>>
