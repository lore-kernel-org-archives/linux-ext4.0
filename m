From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: update uninitialized-block-groups.patch and mballoc-core.patch
Date: Fri, 05 Oct 2007 15:26:28 +0200
Message-ID: <47063B84.7020808@bull.net>
References: <47036832.7030107@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:38431 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443AbXJEN0k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Oct 2007 09:26:40 -0400
In-Reply-To: <47036832.7030107@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Aneesh Kumar K.V wrote:
> +    if (block_group =3D=3D sbi->s_gdb_count - 1) {
> +        /*
> +         * Even though mke2fs always initialize first and last group
> +         * if some other tool enabled the EXT4_BG_BLOCK_UNINIT we ne=
ed
> +         * to make sure we calculate the right free blocks
> +         */
> +        free_blocks =3D ext4_blocks_count(sbi->s_es) -
> +                le32_to_cpu(sbi->s_es->s_first_data_block) -
> +                (EXT4_BLOCKS_PER_GROUP(sb) * sbi->s_groups_count) -
> +                bit_max;
> +    } else {
> +        free_blocks =3D EXT4_BLOCKS_PER_GROUP(sb) - bit_max;
> +    }

Hi Aneesh,

I found a bug in the latest uninitialized-block-groups patch.
(block_group =3D=3D sbi->s_gdb_count - 1)  must be replaced by
(block_group =3D=3D sbi->s_groups_count - 1) in the ext4_init_block_bit=
map()=20
function.

(Seen while testing the mballoc feature with uninit_groups option=20
enabled. fsck reported an error on this group.)

   Val=E9rie
