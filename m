From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC PATCH -V3 9/9] ext4: Fix lockdep recursive locking warning
Date: Fri, 07 Nov 2008 16:04:40 +0800
Message-ID: <4913F698.30309@cn.fujitsu.com>
References: <1225997374-10846-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53392 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYKGIH1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Nov 2008 03:07:27 -0500
In-Reply-To: <1225997374-10846-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I got compile error on IA64:

fs/ext4/mballoc.c: In function =E2=80=98ext4_mb_add_groupinfo=E2=80=99:
fs/ext4/mballoc.c:2482: error: implicit declaration of function =E2=80=98=
__init_rwsem=E2=80=99


Aneesh Kumar K.V wrote:
> Indicate that the group locks can be taken in loop.
>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/mballoc.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>=20
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index f58de20..34b9b7c 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2413,6 +2413,7 @@ ext4_mb_store_history(struct ext4_allocation_co=
ntext *ac)
>  #define ext4_mb_history_init(sb)
>  #endif
> =20
> +static struct lock_class_key alloc_sem_key[NR_BG_LOCKS];
> =20
>  /* Create and initialize ext4_group_info data for the given group. *=
/
>  int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group=
,
> @@ -2473,7 +2474,9 @@ int ext4_mb_add_groupinfo(struct super_block *s=
b, ext4_group_t group,
>  	}
> =20
>  	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
> -	init_rwsem(&meta_group_info[i]->alloc_sem);
> +	__init_rwsem(&meta_group_info[i]->alloc_sem,
> +			"&meta_group_info[i]->alloc_sem",
> +			&alloc_sem_key[i]);
>  	meta_group_info[i]->bb_free_root.rb_node =3D NULL;;
> =20
>  #ifdef DOUBLE_CHECK
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
