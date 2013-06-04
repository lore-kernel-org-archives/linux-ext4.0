From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: detect invalid extents at the end of an extent-block
Date: Tue, 04 Jun 2013 14:53:51 -0500
Message-ID: <51AE45CF.6070901@redhat.com>
References: <20130403190841.GA16276@fury.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060308080609050201000109"
Cc: linux-ext4@vger.kernel.org
To: David Jeffery <djeffery@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab3FDTxx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 15:53:53 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r54JrqOj018788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 4 Jun 2013 15:53:53 -0400
In-Reply-To: <20130403190841.GA16276@fury.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060308080609050201000109
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 4/3/13 2:08 PM, David Jeffery wrote:
> e2fsck does not detect extents which are outside their location in the
> extent tree.  This can result in a bad extent at the end of an extent-block
> not being detected.
>     
> From a part of a dump_extents output:
>     
>  1/ 2  37/ 68 143960 - 146679 123826181               2720
>  2/ 2   1/  2 143960 - 146679 123785816 - 123788535   2720
>  2/ 2   2/  2 146680 - 147583 123788536 - 123789439    904 Uninit <-bad extent
>  1/ 2  38/ 68 146680 - 149391 123826182               2712
>  2/ 2   1/  2 146680 - 147583     18486 -     19389    904
>  2/ 2   2/  2 147584 - 149391 123789440 - 123791247   1808
>     
> e2fsck does not detect this bad extent which both overlaps another, valid
> extent, and is invalid by being beyond the end of the extent above it in
> the tree.
>     
> This patch modifies e2fsck to detect this invalid extent and remove it.

Here's an image which demonstrates this, current e2fsck does not detect
the error.

-Eric

> Signed-off-by: David Jeffery <djeffery@redhat.com>
> ---
>  e2fsck/pass1.c   |   13 +++++++++----
>  e2fsck/problem.c |    6 ++++++
>  e2fsck/problem.h |    1 +
>  3 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index a20b57b..198e9a0 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -1848,7 +1848,7 @@ void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino,
>  
>  static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
>  			     struct process_block_struct *pb,
> -			     blk64_t start_block,
> +			     blk64_t start_block, blk64_t end_block,
>  			     ext2_extent_handle_t ehandle)
>  {
>  	struct ext2fs_extent	extent;
> @@ -1891,6 +1891,9 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
>  			problem = PR_1_EXTENT_BAD_START_BLK;
>  		else if (extent.e_lblk < start_block)
>  			problem = PR_1_OUT_OF_ORDER_EXTENTS;
> +		else if (end_block &&
> +			 (extent.e_lblk + extent.e_len) > end_block)
> +			problem = PR_1_EXTENT_END_OUT_OF_BOUNDS;
>  		else if (is_leaf && extent.e_len == 0)
>  			problem = PR_1_EXTENT_LENGTH_ZERO;
>  		else if (is_leaf &&
> @@ -1937,10 +1940,11 @@ fix_problem_now:
>  		}
>  
>  		if (!is_leaf) {
> -			blk64_t lblk;
> +			blk64_t lblk, lblk_end;
>  
>  			blk = extent.e_pblk;
>  			lblk = extent.e_lblk;
> +			lblk_end = extent.e_lblk + extent.e_len;
>  			pctx->errcode = ext2fs_extent_get(ehandle,
>  						  EXT2_EXTENT_DOWN, &extent);
>  			if (pctx->errcode) {
> @@ -1965,7 +1969,8 @@ fix_problem_now:
>  				if (fix_problem(ctx, problem, pctx))
>  					ext2fs_extent_fix_parents(ehandle);
>  			}
> -			scan_extent_node(ctx, pctx, pb, extent.e_lblk, ehandle);
> +			scan_extent_node(ctx, pctx, pb, extent.e_lblk,
> +					 lblk_end, ehandle);
>  			if (pctx->errcode)
>  				return;
>  			pctx->errcode = ext2fs_extent_get(ehandle,
> @@ -2084,7 +2089,7 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
>  		ctx->extent_depth_count[info.max_depth]++;
>  	}
>  
> -	scan_extent_node(ctx, pctx, pb, 0, ehandle);
> +	scan_extent_node(ctx, pctx, pb, 0, 0, ehandle);
>  	if (pctx->errcode &&
>  	    fix_problem(ctx, PR_1_EXTENT_ITERATE_FAILURE, pctx)) {
>  		pb->num_blocks = 0;
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index 76bc1d5..b0a6e19 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -1008,6 +1008,12 @@ static struct e2fsck_problem problem_table[] = {
>  	     "Logical start %b does not match logical start %c at next level.  "),
>  	  PROMPT_FIX, 0 },
>  
> +	/* Extent end is out of bounds for the tree */
> +	{ PR_1_EXTENT_END_OUT_OF_BOUNDS,
> +	  N_("@i %i, end of extent exceeds allowed value\n\t(logical @b %c, physical @b %b, len %N)\n"),
> +	  PROMPT_CLEAR, 0 },
> +
> +
>  	/* Pass 1b errors */
>  
>  	/* Pass 1B: Rescan for duplicate/bad blocks */
> diff --git a/e2fsck/problem.h b/e2fsck/problem.h
> index d2b6df4..fcdc1a1 100644
> --- a/e2fsck/problem.h
> +++ b/e2fsck/problem.h
> @@ -589,6 +589,7 @@ struct problem_context {
>  /* Index start doesn't match start of next extent down */
>  #define PR_1_EXTENT_INDEX_START_INVALID	0x01006D
>  
> +#define PR_1_EXTENT_END_OUT_OF_BOUNDS	0x01006E
>  /*
>   * Pass 1b errors
>   */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--------------060308080609050201000109
Content-Type: application/x-bzip2;
 name="testfs.img.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="testfs.img.bz2"

QlpoOTFBWSZTWSI7wQcAAo5/////////////////////////////////////////////4Cv/
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
AAAAAAAAAAAAAAAAAAAAAAAAGQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAA1cHhbbnPuM5jvODwen6rW3lrce4/bpu8tq6DveJ3vCarat7r1LY3S5TkDY3uxsaYlLY6
lt7G9nY2MOHpG/4bf7/m+83+/29vb2+K29vit4tvitvb+BXr169evXr169fd44zko5SMdFGM
YxjGMYxu3bt27du3bt27du3bt276WVlZWVlZXscr4GVlZWs9brNHrIOjgj0sALmloi3LlC5Z
62yyzgKUouy0WnT0rHTSNNPAUUaKaKKZwg7lgomZxU0AxgAwKk2BgYGBRRRRRRRRRRRRRRRR
RRi6MXRRe0VqKK2Vnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn4ueeeefk7+/v7+/sWPdWKU2B
j6bnTTOqUnTTRM4KaTM4zRTMzMqaUmZmZnBRMzipmZmVMzNRYhy3VJJJJJJJJJJJJJJJXqSS
SSSSSSSSSSSSSSSSSSSSSsTfPx9N0zpnVKUzpomcFKmZmVMzMzEzMzKmcFEzOKmZxmcFMzMl
9CV8b3ve973ve7bbbbbbbbb3rta1rWta1rbu7u7uySSSSSSSSSZ6rnZ1zs6dHnXc69enXp3e
zr0iJnBTMzMqZmZlAAiigDFBgGCAMpWWZmZmZmZ3pJJJJJJJJJ2zvbu7u7u7u7u7a1rXbbbb
5Jtttttu7b3i2qKFCKQogMN/MzMoAEACKKAMUACAHMNtjbbdttttttvhLbb39vbbbbbbbbbb
bbba2222222222+PS2qKFCKQogMEACABAG84jQtFFGjRoxQAIAcptttttttt22222223tttt
tttttttttttvptvqFbbbbbbdltUUKEUhRAYIDEpAAQACKKAMUAG/mZJeEJtu1rWta1rWta1r
Wta3F5ySTwskkkkkkmZmZmZmZmZmZmZzzzzzzzzzzr3ElvqKFCKQogMIABABAAIooAxRxxxx
04444457OnPPPNzMzMzMzMzMzMzLJJJ2ySSSSSSXd3d3d3d3d3d3dtttttt3p532devSOqdj
wSS0UhRGjRguBpmZlAAgASKKAMQC8vLy8vH1Hve973+8e973ve973ve973ve973vrPe973ve
973ve973ve973ve9738U973ve973ve99ixY3jHUnTOmdeUpnRAYAAAAYBgUUAYgAAOW22227
bbbbbbbbbbe22222222222222ttttttttt5OjptUUKEUhRAYAAAAAFFAGKAAActtttttttu1
rWta1rbu7vgbu7uySSSSSSSSSZmZmZmZmZmZmZa1vqKFCKQogMAAAAACigDFAAHHGd3MzMzM
zMzMzMskkkkkknbJJJd3d3bWta1rWta1rWbbbbbbbbbbstqihQikKIDAAAwDBAAiigrMkyAg
By22227bbbbbbbbbbb222222222+gW2221tttttttttt22qKFCKQogMEAAAIACigDEAABy22
22222222223bbb22222222222222222222221t5unYui4KFCmkKImcEAAAAAUUAYgXl5efQq
VKj8Q573ve973pJJJJJJJJJfFsYuxYsWLFixYtttttu7u7u7u7u7u7u7I85O54bs6denXpx2
dOnWAwAAAEABRQBiAABuTubm5ubm5ubm5wNfPPPPPPPPPPPPPPPPPPPiM7czMzMzMzMzMzM8
RJJJJnnnnnnnnnnnnwLWta2ezRQoRRKIDAAAAADjs6deOOO+44477js44443u72bu7u7u7u7
u7u7u7u7u7u727u7u7u7u7u7u7u7u7u7u7u7u7u7u7u82ps0UKEUSiAwAADEoABRQBiAAHG9
3ZJJJJJJJJJJJJJJPAkkkkkkkkkkkkkkkkkkkkkkkzw/Z16dOvTjs6dOvXjjuccAAAABSIAx
AAAznO1rWta1rWta1rWtu7skkkk8CSSSSSecZmZmZmZmZmZmZnk3PPOvXr169evXr18KuOpC
UIolEBgAAAAAUiAO+44444444457vPPPPPPPPPPPPPPPPPPPPPO5mZmZmduZmZmZmZskkkkk
kkkkm7u7u7u7vO73PD9nXp069CiUQGAAAAABSIAx4MzMz2GZmb6L3ve6SSSW8pJJJJJJJJK9
SSSSSSSSSSV73ve973ve973ve973u27dR2sIShTRKImcJmZmZmZmZmZmSkQBiAF5mZvove97
3vu73ve973ve6SSSSSSVZJJJJJJJJJJJJJJJJJXve973vydrZ7NIShFEogMAAQAAAUiAMeVm
ZmQBy22223e973bbbbbbbbe9be7u7u7u7u7u7u7JJJJJJJJJmM7PDdnXp069CiUQGAAIAAAK
RAGIAAGU5ZZZZZZmZzzzz3szMzMzMzMzMztzM70kkkkkkkkkzva1rWta1rWta1rWta1s3tYQ
lCmiURM4AAAAAFIgDEACiAY222222222227bbbb23zK2222222222222222221tu1rcds0hK
EUSiAwczMyACAApEAYgAAOW222222222222222962222222222222222222227WtmtmkJQii
UQGCABzMzIAFFAGIAIActtt7u7u7u7u7u7u7vfySeFkkkkkkkkzMzMzMsssssssssssu6ZZZ
ZZa9evj1vqKFCKJRAYAAgAymZmSigDEAAwDLHLLLLLK+eeeeeeeeeeeeeeeeck727u9u7u7u
7u7u7u962222222223vW1u1rZ7NFChFEogMAAACIiCiSSRRJJIokkkUUJJzhETM4oAABy222
223bbbbbbbbbb2222222223wbbbbba22222227WtxezRQoRRKIDBAByszMygp3l5TdCpTdNU
qVN0fUqVKlT6dSpUqQxEIQhCEIQhCEIQhCEIQhCEIQhCEIVoQhCEIQhCEIQhCEIQhCEIQhCE
IQhCEIQhDg8Hg2tbNbNFChFEogMIACFEREJJJQoQAAAUUAY9k6z3vTp06dPV+9aNHR+R2Nji
PCLkN333hMIjhFSIShdF0dAKoiVwADW0KKKChIoJSCCnrohgiI7aCgONeog3IgoLjQUXcwEM
iIJICq34oBhxE00FROm4I4CClUTZ0QVUc7EFAc1ES9ASkEL0VRUz8BBQEESnR9h11A9fXZJU
8HsPbdVnvc9eYoKrJv3cYeFE4iYmauXdhsNdwvXavU8Zf5X1mj8/deTx3jff+79jwO/731e1
+R1ukr6XF7xxGO0GTvcnn+Kw+Ir4dfHaHG18POZ3CyXE6XTfLw+H0PZbvq5ugp5J0qU2N1tO
YTl4KHFQE7KOw02oqKtPQLl3geJv37+Hfv379+/fv3/VZBkZGRxORkZGRkZGRhnX28rzHGfG
9OFUBeMnNlhRDTQE5zgN+q0b0+6OPHjx48ePHjx48ePHjx48fGvn8/n8/n8/n8nP567qfeHH
na/Z/ibo+MrEeOqKd3A0kdlyFFQOagiCIW2222222222222222222222222222224mk4qnG5
+nIRNVC4nLclKhc1jY2NjYeNjY2NjY0zMzMzMzMzMzM9fH2ndfPON9YiIj0VcYxjGMdTjGMY
xjGMYxjGMYxjGMY+oaikdCtPGV5tb3ve973ve973ve973vi4uLi4uLi4uLdQqIHeeh+HQdBL
NDTkcmldyUhCEkjJLk7Ssemrv379+/fv379+/fv379+/fv379/Yb9+/fO/fpyRv7ndSkRGla
RFKeIrF73ve973ve973ve973ve973ve9/U8LuIpSI8zWPV1xjGMYxjGMYxjGMYxjGMYxjGMY
x1X39r1pG3jN3cx6Ssf81T93W0DZ3Aos9lNxOF4+lttttttttttttttvprbbbbbbeHtttt6H
Q6HfuT9/obqRHre839vTpKTMzMzMzMzMzMzMz4WZmZmZ9fand/Xbo7DfupT9j9nzHMjOc5zn
OepznOc5znOc5znOc5znOed33fdR33fd9j2nDdSKZznqM5znOc5znOc5znPOznOc5znPsUqR
2dYbbbbbbbbbbbbbbbfTeS/+W6K/Eeap+d+9u9RWOlikVrSkV06bmVrXSu6KRv3RpFa7tNNN
NNNNNNNNNNNNNNNNNFpppppppyR66sUp29aREYrSKRRttttttttttttttt+RsqxERSEkkkkk
kkkkkkkkkl1nJHm1up+B4v3DmR3PlN0ZznOc5znOesznOc5znOc5znOc5zyTWnqq0SSSSSSS
SSSSSSSSXJRVppWiSSSSSSSSSSSSSSS5bQ6xEe6ViG222222222222223yKsUta1rWta1rWt
a1rWta1rWta1rWru+MrRJVrWta1rWta1rWta14mta1rWta1r+xVhJLndIilI7isUbbbbbbbb
bbbbbbbfJ2ELdFKUj5qsUpTnVSSXTrvySSSSSSSSSSS8laOY91PfPK7qXve973ve973ve973
ve973ve91fkdYpza2ta1rWta1rWta1rWta1rWtb2y1rcnbUW6m6tawkkkkkkkkkkkkkkkvtb
J7qU8fWO6r5WsTMzMzMzMzMzMzMzMzMzMz2tudjdEeppWOtq22+nbbbbfVtttttttvky90UV
Y9trubbbbbbbbbbbbbbbnvPN9q/N+Y7vH5vN5LgMzkc3nM7ns3juezOc6PnOWsZDBzue1+v+
v9Lieo7rYdHsLXd8dydq1atWs9fWrVq1ay1p+nw7WbtdXqstsOd2HeZoOY5q3b7G3bt5i3bt
27fZW8Hv9cd+aozWruXO1udx2mcudnp9HcuXNDc11zvLly5hXLlzvQNTsAO3DVAB2xrAADtf
2AB4+vDxNmbLZfk2Wy2XheT5PlXLgeWHjHiB5m2A2W1DzgNmekegB5p6fqAHo+wHqf5D0z2T
cXdzH1Q/5Lcy/97DMwMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMz
MzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzSlKU
pSlKUpSlKUpSlKUpSlKUpSlKUpSlKUpSlKUpSlKUpSlKUpSlKUpSlKUpNMOXgoocNDw6qAld
KAkpRd7mGXXl5hVc4mYL1L3o7v8/pbXzPL8bwu+tdv97set1Gj0HTfV57L/RoschxmRyGOxO
KxVPduApudM6a99mm5zpt/jjN/6XteljmaaaaaaaaaaaaaaaaaaaaaaaaLTTTTTnaf/f9f6f
3+y/l/g/d9f631n5Xqfw/S+j+2+w+r+m895z5jzPx/xXlvgvfve+48XWI8dWAJAAAAAAAAAA
AAAAAPQfSed858z5r5L43y/lvI+T7grEdSboAAAAAAAAAAOm8h5D/f2ns/Zfz/xew/b/X9b+
f6vvfxvTel9IAAAB3EeUrBWAAAAAAAA9vAAAAAAAADbbbbbbbbbbbbbWKQVgAAAAAAAAAAAA
AAAAAAAAPH+Bqarb6ty1VVVVVVVVVVVVVVVVVVVVcNVVVVVVy8vLy8vLy8vLy8vLy8vLy8vL
y8vL6PbWkFYAAADsgAAAAAAAA2222222222222222222222227iIiIK0iIp3dYAAAAAAAAAA
AAAAAAAAAO77v4Pyfnc+e3ef6SO55adpWIikR8BXy/R6PR6PR6PR6PR6OrVq1atWrVxOrVq1
aq6tWrVq1V42iita1rWta1rWta1rWta1rW1rWta1rR+RWISSSSSSSSSSSSSSSXgOqVojvKwk
kkkkkkvBpL2pJJJJJK0Uj/v+v4uOZF73ve973ve973ve973ve973ve91dOPZREbvP1jfWJmZ
mZmZmZmZmZmZmZmZmZ6/FoV/V/+czpI5le0rEzMzM+Bma1atWrVq1atWrVq1atWrVq1atwdm
zZs5azj7OMs2bNmzZs2bNnBwcHBwcHjcHB7Pt28qtqtq99bXa1ula9VrW1b+bnFa5JJJJJJJ
JJJJJJy6SSczkkkkkkkkkkkkkk4jgdUm5q1W1Wtw03LSSSSSSSSSSSSSSTmUkkkkkkkkkkkk
kkk2cD51rZtbG867rtfXa973ve973ve973ve973ve973ve973ve973ve9730000000000000
00003fQ69U12kkkkkkkkkkkkkkknJJJJJJJJJJJJJJJJJN21tLW89v95ate811VVVVVVVVVc
ZVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVXAtqts123d3d11111111111111111111111111111
112AAAAAAAAANYjpzdAAAAAAAAAABzgAAAAAAAAAO921pBWAJAAAAAAAAAAAAAAAADbbbbbb
bbuIiIgrSIihWAAAAAAAAAADpgAAAAAAAAAA1oqxSkRHrqx1+26NtttpJJJJJJJJJvpJJJJJ
JJJJJJJJJJJJJOBb4vG9izwlrX12ve973ve973ve973ve973ve973ve973ve973000000000
0000000000003bW2a9WzZs2bNmzZs2bAAAAAAA6wAAAAAAAAAANYgrAAAAdkAAAAAAAAAAAA
AAAABrFIKwAAAAAAAAAAAAAAAAAAAAHbGsR6LqtuZaSSSScjkkkkkkkkkkk4iSSSSSSSTbbb
bbbbbbbbbbbsaR7D3HcVgA6UAAAAAAAAAAAAAADbbbbbbbbbbbbuIjnVp8t71G6kUjdB5iK8
XXRA0fO0ecgU5PTypDZ3+PqL9+/fv37+Hfv379/OYxjGMYxjh8YxjGMcVyHGMc54nGNzGMYx
jGMYxjGMYxjGMYx7n4SnivF7qUikR2Bug5oAAAAAdsAAAAAAAAAAAAAHiivXxFaa1jXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXUOIAAAAAAGzd/Da2vVNdpJJJJJJJJJJJJJJJOHkkk
m222222222222222222wG1u42rEFYAAOAAAAAAAAgAAAAAAAAPFAGsUgrAAAAAAAAAAAdIAA
AAAAAAAB2JrEFYAAAAAAAAA7EAAAAADXXXXXXXXXXXXXXUNfExFfG9pu9DFY+X7xpxu3e8Xx
e91cLjGMYxyfGMYxjGMb7GMYxjGMYxjG/tbVjXa2q3GtKUpHkK+xr1tb3ve973ve973v1d73
ve973ve973dopSPHxFaRyxFey3RG7sq8+tKRFJmZmZmZmZmZmZmZmZmZmZ5JrTw1aJJJJJJJ
JJJJJJJJJWiOnr4Wla1K1rWta1rWvD7zpH3ksEl9kwiFSmzSFhSOTjpNIhUXZ3Ojs8HwfBA8
d8+D0oB4Tvw9MeX9OnTp08x7OnTp06/d+sr1HM++imN2MYxjGMYxjGMYxjGMYx7XjGMYxjCi
MKlIpuiIrFKUisVrFexe5ttttttttttttttt8kRatrWSSSSSSSSSSSSSSVqearHf6xEUdaUb
bbbbbbbbbbbbbb7H6OkUpfdvrEOrbbbbbbbbbbbve973vd2ikKqSSSSSSSSSSSSSSSVojrlu
SSSSSSSSSSSSSSSXJSLVta1rWta1rJJJJJJJJJJckREQqxSIoqpJJJJJJJJJJJJJJJWpSKRC
qkkkkkkkkkkkkkkklaIVUkkkkkkkkkkkkkkkrRHUrckkkkkkkkkkkkkkkuSItW1rWta1rWta
1rWtaySSSSSStFIVUkkkkkkkkkkkkkklyKvgvEbqdg9zbbbbbbfg3Vq1atWrVq1atWrVq1cT
tnOpYE+V2e05XEOdlVlYY3jOCDL6DR85x/CAaIMjwwGTCGSA1AZbKAdZ0py/zs/qzrgy9AGr
DneW0GUNYc1z/MhodbojNc2HRa4Om6AD8PVdd0/1g5n6hl9DmwO5DSdRz/adD0QabqQ7bvDU
9nhn3zvg7brAPBDX9h90PDNja1oHjB3v4APDDwe5A2fe7HxLZ45tPIPH8ED94bHxQPPPO8zy
drtT+J5+12h6P9dsG2/gBtw/ttgPWD1fUDb/7D1/WPXP+hudyAwNM5zmKbppt7pTTbpulMEp
Sihl770szMu77MzLxgw83UCh76lD48aQ+W7XuvmVvfe+NJNPNUX9fVelx0UiPuCMfUbrl+X5
dSluqLD6Wj8H25jRQpw3C48zH1Ez2JvfP3Xk/j/F4vhbnb/V4v6Pe95te52n8fvvddh1nUey
9f+zqtRiABjRAdBNAkkkkkl1iSSSSSSSS5ytEUpF6VpHqIrFez3RTtqxSImszPf5mZmZmcYx
jGMYxjGMYmZmbR6qsOrbbbbbbbbbbbbbbbdqR4Jbkkkkkkkkkkkkkkkux6D3R1kcZ73xPNp1
c7pmZmZmZmZ62c5znOc+EznOc5zmbREdCteh1HMi9b3ve973ve973ve973vfwl73ve979hF7
R+LHXXprT1FOZzYU7pmeomZmZmeqmZmZmZmZmZmex9PndHQ8P28dpHs69r0tN9d+/fpppppp
ppppppppppppppppppppppyRERG+tIiI4VpFO36G6OoxuxjGMYxjGMYxjGMYxjGMYxjGMYxy
UpFIi1bWta1rWta1rWta1rWtaySSSXIq9p3u7s/VbomszMzMzMzMzMzMzMzMzMzMr8fL7btN
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
Fze8oOVnbfPoRA21xy+Z39Q5vOqvPhKEQOh0fG6VD4+9yvIoRA3nuvJuWholIBCIAQiEUCGA
ELEMQAhs4FQJQCBOBEN3RJBQJkMUSBAlCoEQyhUCWzkCBKD2UAoEoK0IgShUCAUFVBEggbVA
eomg8aEU3ECIceF4EInJhyYE23b7evc7vc5fC4PD4nEzOLxvE33H0vI0vC5N/4uHmZvt+Vnc
Hg8XLz+X5j0PouPWuPHj2Ljx5XK5XK5jjx48fCcePHjx48vt6P0jzQAAAAAAAAAAAAAAAAAA
AAAAAKqqqqqqqqqqqqqqqqqqqqqqqgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAecqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq
qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq
qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqgAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAcNeHLdL5OOhDVdnIxdRJAqHc4mBNofXa3AmGTrtdZs2bO
is2dDZvbNm8s79+/fv379+/fxuPuPHx944+Pj4/R7bbbbbbbbbbbbbbbbbbbes5OTk5OTk5M
3N3Gbyc3N5va0ivgQAdtCAdpBy7mUQnaQhw4XJycnJ4cOHDhw4cOHDhw4crhyuHDmOHL8OHN
5mZmZmZmZmZmZmZmZlNNNNNOyppppp2eRkZGRkXAd3CCEEEQRBEMRERj4+OAAAAAAAAAAAKa
6aaVVa1rrrWuuuumuuuutA33qqqqqqoAAAzMzMzMzMzMzMzNtNdtPAaacnXXXTTTk6cnXTk8
nka66ZmZmZwAAAOFVVVVVVcN99999999999wCXWmlVXY9a0q7u7u7u7u7u7u+k3d3fKu7qqq
qqqqqqqqqqquua6aa6ac759ydNaqqqqqqqqqqqqqqqqqq7PXaqqqqtNdddNOxcjWqqqqqq6G
AAAZmZmZmZmZmZmZm222222222muumunDXTvfIchyHIAABwqqqru7u7u7gAABJJJJJpVac1W
taaaVxa1VcXFxc7kkkkkkkkkkknMSSSSSSSSSSSSSSSTqEkkkkkknQ6qtKoAAAAAAAAAAABW
laVQAC7u7u7u7u7u7u4AAAzMzMzMzMzMzuWumjTTTXTQABwqqqqqqrhvvvvvvvvvvvvvvvvu
JJJJJJJJI00rSq6cAAAAAAAdbAAAADSq0qgAAAAAAAAAAAGlVpVAu7u7u7qqqrpAAABmZmZm
ZmZmZmZmbbdZ1110004abbbbbcMzMzMzMzMzMzMzgAAAcKqqqqqq4b776666aaVVVVVVVVVV
VVVVVVVVVVVVVVa6aa6aVVVVVVVVVVVVVVVVVVVVVVVVa666aaVVVVVVAAAHVczMzMzMzMy+
++++/S222228rSlIiG222222228m++++++/MzMzMzMzIAAAqqqq1110quKu+1JJJJOf1JJJJ
JJJJJJJJJJJJJJJJJJJJJJJJJJJ22pVaVVa1prpJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
JJI0qtKrzoEkkAADfffeqqqqqqjsgAAc/100100zMzM22224ZmZmZmZmZmZmZnAAADmual3d
3d3d3d3d3ZVVpVAAAAA5kAAAAAADfVaVVNdAAAAAAAAAAAAXpppVU1ou7u7qqqqrooAABmZm
ZmZmZmZmZmbbbbbctrprpppt4Hk6ZnAAAA4VVd3d3d3d3d3AAACSSS600qqmtAAAAAAADrgA
AABy+laVVc3rmtcXn8zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMymmmmmmmmnulBA
ARE3O45W0zbWwu+719cziARJwCLlQIioGVXkIs4AROZCJ58CAmDC0EIiA86AH1sAJEACDcF3
CDmTFRRe4gEqQCShQuIQcyFAVlCCaOAEVQRE73k8aTKOHQSeRv9FRl9CS5u/zzS393l6nUan
gZ3N1G/5t9wzlHKOZnZZqcPU5/LwuZh8Xq601QfdgE50CjmQY+JiznfWZ2YHzGEW8w7GgKBF
xYp61fx8S+1VZNaQIWoFArVpIIXECKIBjYki5gZpAmHq7e3t+xlvdz7za+z7rZ6f4fkYHz/O
6es/H1P2/y/t1cPSP/dPn4CjLA0+BgdWrqtfa7fo9Hm3lz6fLLLLLLLLLLLLLLLLLLLLLpqY
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
JOp4ig==
--------------060308080609050201000109--
