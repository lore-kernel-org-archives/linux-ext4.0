From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH] [Coding Style]: fs/ext{3,4}/ext{3,4}_jbd{,2}.c
Date: Fri, 04 Jan 2008 14:41:51 +0100
Message-ID: <477E379F.4000103@student.ltu.se>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-2-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-3-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-4-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-5-git-send-email-mathieu.segaud@regala.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Mathieu Segaud <mathieu.segaud@regala.cx>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753394AbYADNmR@vger.kernel.org>
In-Reply-To: <1199452896-20145-5-git-send-email-mathieu.segaud@regala.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Mathieu Segaud wrote:
> Misc style fixes from checkpatch.pl
>
> Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>
> ---
>  fs/ext3/ext3_jbd.c  |   12 ++++++------
>  fs/ext4/ext4_jbd2.c |   12 ++++++------
>  2 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/fs/ext3/ext3_jbd.c b/fs/ext3/ext3_jbd.c
> index e1f91fd..6c96260 100644
> --- a/fs/ext3/ext3_jbd.c
> +++ b/fs/ext3/ext3_jbd.c
> @@ -9,7 +9,7 @@ int __ext3_journal_get_undo_access(const char *where, handle_t *handle,
>  {
>  	int err = journal_get_undo_access(handle, bh);
>  	if (err)
> -		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
> +		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle, err);
>  	return err;
>  }
>  
> @@ -18,7 +18,7 @@ int __ext3_journal_get_write_access(const char *where, handle_t *handle,
>  {
>  	int err = journal_get_write_access(handle, bh);
>  	if (err)
> -		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
> +		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle, err);
>  	return err;
>  }
>  
> @@ -27,7 +27,7 @@ int __ext3_journal_forget(const char *where, handle_t *handle,
>  {
>  	int err = journal_forget(handle, bh);
>  	if (err)
> -		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
> +		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle, err);
>  	return err;
>  }
>  
> @@ -36,7 +36,7 @@ int __ext3_journal_revoke(const char *where, handle_t *handle,
>  {
>  	int err = journal_revoke(handle, blocknr, bh);
>  	if (err)
> -		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
> +		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle, err);
>  	return err;
>  }
>  
> @@ -45,7 +45,7 @@ int __ext3_journal_get_create_access(const char *where,
>  {
>  	int err = journal_get_create_access(handle, bh);
>  	if (err)
> -		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
> +		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle, err);
>  	return err;
>  }
>  
> @@ -54,6 +54,6 @@ int __ext3_journal_dirty_metadata(const char *where,
>  {
>  	int err = journal_dirty_metadata(handle, bh);
>  	if (err)
> -		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
> +		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle, err);
>  	return err;
>  }
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index d6afe4e..2256c43 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -9,7 +9,7 @@ int __ext4_journal_get_undo_access(const char *where, handle_t *handle,
>  {
>  	int err = jbd2_journal_get_undo_access(handle, bh);
>  	if (err)
> -		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
> +		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle, err);
>  	return err;
>  }
>  
> @@ -18,7 +18,7 @@ int __ext4_journal_get_write_access(const char *where, handle_t *handle,
>  {
>  	int err = jbd2_journal_get_write_access(handle, bh);
>  	if (err)
> -		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
> +		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle, err);
>  	return err;
>  }
>  
> @@ -27,7 +27,7 @@ int __ext4_journal_forget(const char *where, handle_t *handle,
>  {
>  	int err = jbd2_journal_forget(handle, bh);
>  	if (err)
> -		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
> +		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle, err);
>  	return err;
>  }
>  
> @@ -36,7 +36,7 @@ int __ext4_journal_revoke(const char *where, handle_t *handle,
>  {
>  	int err = jbd2_journal_revoke(handle, blocknr, bh);
>  	if (err)
> -		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
> +		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle, err);
>  	return err;
>  }
>  
> @@ -45,7 +45,7 @@ int __ext4_journal_get_create_access(const char *where,
>  {
>  	int err = jbd2_journal_get_create_access(handle, bh);
>  	if (err)
> -		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
> +		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle, err);
>  	return err;
>  }
>  
> @@ -54,6 +54,6 @@ int __ext4_journal_dirty_metadata(const char *where,
>  {
>  	int err = jbd2_journal_dirty_metadata(handle, bh);
>  	if (err)
> -		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
> +		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle, err);
>  	return err;
>  }
>   
Hi Mathieu

What about changing the __FUNCTION__ to __func__, while you are at it?

Richard Knutsson
