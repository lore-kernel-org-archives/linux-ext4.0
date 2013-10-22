From: "Dilger, Andreas" <andreas.dilger@intel.com>
Subject: Re: [PATCH] e2fsck: fix problem comments to match actual message
Date: Tue, 22 Oct 2013 04:12:51 +0000
Message-ID: <CE8B568C.789CE%andreas.dilger@intel.com>
References: <1382414047-93725-1-git-send-email-andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "tytso@mit.edu" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22075 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab3JVEMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Oct 2013 00:12:53 -0400
In-Reply-To: <1382414047-93725-1-git-send-email-andreas.dilger@intel.com>
Content-Language: en-US
Content-ID: <E81606FDFB248149AF23BC43F4C23F61@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013/10/21 9:54 PM, "Dilger, Andreas" <andreas.dilger@intel.com> wrote:

>Fix the e2fsck problem comments to match the actual message printed,
>so that it is possible to find the problem code when searching by
>the message.

Ted,
have you thought about getting rid of the error message compression in
e2fsck?  I think the compression isn't useful anymore, and the escape
codes makes it much harder to debug and understand the code.

Cheers, Andreas

>Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
>---
> e2fsck/problem.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/e2fsck/problem.c b/e2fsck/problem.c
>index b0a6e19..2a6c937 100644
>--- a/e2fsck/problem.c
>+++ b/e2fsck/problem.c
>@@ -1118,12 +1118,12 @@ static struct e2fsck_problem problem_table[] = {
> 	  N_("@n @i number for '.' in @d @i %i.\n"),
> 	  PROMPT_FIX, 0 },
> 
>-	/* Directory entry has bad inode number */
>+	/* Entry 'xxxx' in /a/b/c has bad inode number.*/
> 	{ PR_2_BAD_INO,
> 	  N_("@E has @n @i #: %Di.\n"),
> 	  PROMPT_CLEAR, 0 },
> 
>-	/* Directory entry has deleted or unused inode */
>+	/* Entry 'xxxx' in /a/b/c has deleted/unused inode nnnnn.*/
> 	{ PR_2_UNUSED_INODE,
> 	  N_("@E has @D/unused @i %Di.  "),
> 	  PROMPT_CLEAR, PR_PREEN_OK },
>-- 
>1.7.11.5
>
>


Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


