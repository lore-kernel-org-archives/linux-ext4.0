From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: delete unused mapping variable
Date: Thu, 13 Jun 2013 10:19:37 -0400
Message-ID: <20130613141937.GG13429@thunk.org>
References: <1371131298-2059-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57681 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab3FMOTi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Jun 2013 10:19:38 -0400
Content-Disposition: inline
In-Reply-To: <1371131298-2059-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 13, 2013 at 09:48:18AM -0400, Paul Gortmaker wrote:
> The code refactoring in commit "ext4: refactor punch hole code"
> left behind a now unused variable, causing:
>=20
> fs/ext4/inode.c: In function =E2=80=98ext4_punch_hole=E2=80=99:
> fs/ext4/inode.c:3495:24: warning: unused variable =E2=80=98mapping=E2=
=80=99 [-Wunused-variable]
>=20
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Thanks, I had actually noticed this already, but I had pushed out the
wrong version to the dev branch.

				- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
