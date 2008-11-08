From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC PATCH -V3 9/9] ext4: Fix lockdep recursive locking warning
Date: Sat, 08 Nov 2008 09:21:58 +0800
Message-ID: <4914E9B6.8030109@cn.fujitsu.com>
References: <1225997374-10846-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4913F698.30309@cn.fujitsu.com> <20081107162211.GN25194@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65398 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbYKHBYk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Nov 2008 20:24:40 -0500
In-Reply-To: <20081107162211.GN25194@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Fri, Nov 07, 2008 at 04:04:40PM +0800, Li Zefan wrote:
>> I got compile error on IA64:
>>
>> fs/ext4/mballoc.c: In function =E2=80=98ext4_mb_add_groupinfo=E2=80=99=
:
>> fs/ext4/mballoc.c:2482: error: implicit declaration of function =E2=80=
=98__init_rwsem=E2=80=99
>>
>>
>=20
> Can you try this patch. I guess IA64 doesn't support lockdep
>=20

Yes, it's not supported on IA64.

> ext4: Fix lockdep recursive locking warning
>=20

I manually did the same as this patch yesterday, and I've confirmed the
patch past compile.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
