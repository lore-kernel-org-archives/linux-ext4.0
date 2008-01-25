From: Junio C Hamano <junio@pobox.com>
Subject: Re: [PATCH] Convert ext4_ioctl to an unlocked_ioctl
Date: Thu, 24 Jan 2008 22:35:16 -0800
Message-ID: <7vir1i76qj.fsf@gitster.siamese.dyndns.org>
References: <1201007375-27914-1-git-send-email-mathieu.segaud@regala.cx>
	<1201007375-27914-2-git-send-email-mathieu.segaud@regala.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, sct@redhat.com,
	Mathieu Segaud <mathieu.segaud@regala.cx>
To: Mathieu Segaud <mathieu.segaud@regala.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:53104 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbYAYGf1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jan 2008 01:35:27 -0500
In-Reply-To: <1201007375-27914-2-git-send-email-mathieu.segaud@regala.cx>
	(Mathieu Segaud's message of "Tue, 22 Jan 2008 14:09:34 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mathieu Segaud <mathieu.segaud@regala.cx> writes:

> Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>
> ---
>  fs/ext4/dir.c           |    2 +-
>  fs/ext4/file.c          |    2 +-
>  fs/ext4/ioctl.c         |  161 ++++++++++++++++++++++++++++++++---------------
>  include/linux/ext4_fs.h |    3 +-
>  4 files changed, 112 insertions(+), 56 deletions(-)
>
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index f612bef..8f6677a 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -42,7 +42,7 @@ const struct file_operations ext4_dir_operations = {
>  	.llseek		= generic_file_llseek,
>  	.read		= generic_read_dir,
>  	.readdir	= ext4_readdir,		/* we take BKL. needed?*/
> -	.ioctl		= ext4_ioctl,		/* BKL held */
> +	.unlocked_ioctl	= ext4_ioctl,		/* BKL held */

Wasn't the purpose of this whole exercise to eventually allow
them to be outside BKL?  IOW, don't you want to drop this
comment for the .unlocked_ioctl member of this struct?
