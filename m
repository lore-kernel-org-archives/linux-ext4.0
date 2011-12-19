From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH 20/51] e2fsck: Verify extent tree blocks and clear the bad ones
Date: Mon, 19 Dec 2011 07:50:07 +0100
Message-ID: <FC050168-CB90-4951-9FE7-9D02596E0E23@whamcloud.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com> <20111214011531.20947.535.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Coly Li <colyli@gmail.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35638 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab1LSLSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Dec 2011 06:18:08 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so5325769eek.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 03:18:07 -0800 (PST)
In-Reply-To: <20111214011531.20947.535.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-12-14, at 2:15, "Darrick J. Wong" <djwong@us.ibm.com> wrote:

> When we encounter an extent tree block that passes the header check but fails
> the checksum, offer to clear just that extent block instead of failing the
> whole tree, which results in the entire inode being wiped out.
> 
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index e74ad79..96b0de5 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -946,6 +946,12 @@ static struct e2fsck_problem problem_table[] = {
>      N_("The bad @b @i looks @n.  "),
>      PROMPT_CLEAR, 0 },
> 
> +    /* Extent block does not match extent */
> +    { PR_1_EXTENT_CSUM_INVALID,
> +      N_("@i %i extent block checksum does not match extent\n\t(logical @b "
> +         "%c, @n physical @b %b, len %N)\n"),
> +      PROMPT_CLEAR, 0 },

Since the comment above the problem definition is the only place that the full string can be found, it should match the printed string exactly. In this case it is missing "inode" at the start and "checksum" in the middle of the comment. 

Cheers, Andreas