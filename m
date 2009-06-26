From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: [PATCH] naturally align struct ext4_allocation_request
Date: Thu, 25 Jun 2009 20:50:16 -0400
Message-ID: <170fa0d20906251750u697b32e3yb92eab53b51556a3@mail.gmail.com>
References: <4A4254C2.8000609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:58761 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZFZAuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Jun 2009 20:50:14 -0400
Received: by ewy6 with SMTP id 6so2873752ewy.37
        for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2009 17:50:16 -0700 (PDT)
In-Reply-To: <4A4254C2.8000609@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 24, 2009 at 12:30 PM, Eric Sandeen<sandeen@redhat.com> wrot=
e:
> As Ted noted, the ext4_allocation_request isn't well aligned.
>
> Looking at it with pahole we're wasting space on 64-bit
> arches:
>
> struct ext4_allocation_request {
> =A0 =A0 =A0 =A0struct inode * =A0 =A0 =A0 =A0 =A0 =A0 inode; =A0 =A0 =
=A0 =A0 =A0 =A0 =A0/* =A0 =A0 0 =A0 =A0 8 */
> =A0 =A0 =A0 =A0ext4_lblk_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0logical; =A0=
 =A0 =A0 =A0 =A0 =A0/* =A0 =A0 8 =A0 =A0 4 */
>
> =A0 =A0 =A0 =A0/* XXX 4 bytes hole, try to pack */
>
> =A0 =A0 =A0 =A0ext4_fsblk_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 goal; =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 /* =A0 =A016 =A0 =A0 8 */
> =A0 =A0 =A0 =A0ext4_lblk_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lleft; =A0 =
=A0 =A0 =A0 =A0 =A0 =A0/* =A0 =A024 =A0 =A0 4 */
>
> =A0 =A0 =A0 =A0/* XXX 4 bytes hole, try to pack */
>
> =A0 =A0 =A0 =A0ext4_fsblk_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 pleft; =A0 =A0=
 =A0 =A0 =A0 =A0 =A0/* =A0 =A032 =A0 =A0 8 */
> =A0 =A0 =A0 =A0ext4_lblk_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lright; =A0=
 =A0 =A0 =A0 =A0 =A0 /* =A0 =A040 =A0 =A0 4 */
>
> =A0 =A0 =A0 =A0/* XXX 4 bytes hole, try to pack */
>
> =A0 =A0 =A0 =A0ext4_fsblk_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 pright; =A0 =A0=
 =A0 =A0 =A0 =A0 /* =A0 =A048 =A0 =A0 8 */
> =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0 =A0 len; =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0/* =A0 =A056 =A0 =A0 4 */
> =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags; =A0 =A0=
 =A0 =A0 =A0 =A0 =A0/* =A0 =A060 =A0 =A0 4 */
> =A0 =A0 =A0 =A0/* --- cacheline 1 boundary (64 bytes) --- */
>
> =A0 =A0 =A0 =A0/* size: 64, cachelines: 1, members: 9 */
> =A0 =A0 =A0 =A0/* sum members: 52, holes: 3, sum holes: 12 */
> };
>
> grouping 32-bit members together closes these holes and shrinks
> the structure by 12 bytes.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index cc7d5ed..9a438cf 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -93,20 +93,20 @@ typedef unsigned int ext4_group_t;
> =A0struct ext4_allocation_request {
> =A0 =A0 =A0 =A0/* target inode for block we're allocating */
> =A0 =A0 =A0 =A0struct inode *inode;
> + =A0 =A0 =A0 /* how many blocks we want to allocate */
> + =A0 =A0 =A0 unsigned int len;
> =A0 =A0 =A0 =A0/* logical block in target inode */
> =A0 =A0 =A0 =A0ext4_lblk_t logical;
> - =A0 =A0 =A0 /* phys. target (a hint) */
> - =A0 =A0 =A0 ext4_fsblk_t goal;
> =A0 =A0 =A0 =A0/* the closest logical allocated block to the left */
> =A0 =A0 =A0 =A0ext4_lblk_t lleft;
> - =A0 =A0 =A0 /* phys. block for ^^^ */
> - =A0 =A0 =A0 ext4_fsblk_t pleft;
> =A0 =A0 =A0 =A0/* the closest logical allocated block to the right */
> =A0 =A0 =A0 =A0ext4_lblk_t lright;
> + =A0 =A0 =A0 /* phys. target (a hint) */
> + =A0 =A0 =A0 ext4_fsblk_t goal;
> + =A0 =A0 =A0 /* phys. block for ^^^ */
> + =A0 =A0 =A0 ext4_fsblk_t pleft;
> =A0 =A0 =A0 =A0/* phys. block for ^^^ */
> =A0 =A0 =A0 =A0ext4_fsblk_t pright;

Hey Eric,

Looks like the comments for pleft and pright should be updated to
reference lleft and lright respectively (rather than ^^^).

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
