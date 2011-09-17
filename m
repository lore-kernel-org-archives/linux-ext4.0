From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 21/25] e2fsck: Fix leaks in error paths
Date: Fri, 16 Sep 2011 19:57:02 -0500
Message-ID: <4E73F05E.2080106@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com> <1316206180-6375-22-git-send-email-sandeen@redhat.com> <20110916234113.GY16246@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab1IQA5F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 20:57:05 -0400
In-Reply-To: <20110916234113.GY16246@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/16/11 6:41 PM, Ted Ts'o wrote:
> On Fri, Sep 16, 2011 at 03:49:36PM -0500, Eric Sandeen wrote:
>> fn and/or array was not freed in some error paths.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Applied, but I did make a two changes.
> 
>> @@ -345,6 +346,7 @@ profile_init(const char **files, profile_t *ret_profile)
>>  	     * If all the files were not found, return the appropriate error.
>>  	     */
>>  	    if (!profile->first_file) {
>> +		free_list(array);
>>  		profile_release(profile);
>>  		return ENOENT;
>>  	    }
> 
> I changed this to be:
> 
>  	    if (!profile->first_file) {
>  		retval = ENOENT;
> 		goto errout;
>  	    }
> 
> Which allows us to unify the error cleanup path and avoid duplicating
> code.

Makes sense, now why didn't I do that ... was thinking there was some issue
but sure looks right now!

> Also, I noticed another bug while I was validating your patch.  If the
> realloc() in get_dirlist() fails due to a ENOMEM, and we jump to
> errout, the array hasn't been null terminated yet.  This could lead to
> lead a kernel oops or worse when free_list(array) tries to free the
> array.
> 
> So I added:
> 
> errout:
> +	if (array)
> +	   array[num] = 0;
> 
> to take care of this problem.
> 
> 				- Ted
> 
> commit 04bfa75f42a5adb3510551f4d153526d94be37fb
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Fri Sep 16 15:49:36 2011 -0500
> 
>     e2fsck: Fix leaks in error paths
>     
>     fn and/or array was not freed in some error paths.
>     
>     [ Also make sure the array is NULL terminated before we free it in
>       get_dirlist(). --tytso]
>     
>     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> diff --git a/e2fsck/profile.c b/e2fsck/profile.c
> index 327bfb4..f4267b1 100644
> --- a/e2fsck/profile.c
> +++ b/e2fsck/profile.c
> @@ -276,6 +276,7 @@ static errcode_t get_dirlist(const char *dirname, char***ret_array)
>  			new_array = realloc(array, sizeof(char *) * (max+1));
>  			if (!new_array) {
>  				retval = ENOMEM;
> +				free(fn);
>  				goto errout;
>  			}
>  			array = new_array;
> @@ -290,6 +291,8 @@ static errcode_t get_dirlist(const char *dirname, char***ret_array)
>  	closedir(dir);
>  	return 0;
>  errout:
> +	if (array)
> +		array[num] = 0;
>  	closedir(dir);
>  	free_list(array);
>  	return retval;
> @@ -345,8 +348,8 @@ profile_init(const char **files, profile_t *ret_profile)
>  	     * If all the files were not found, return the appropriate error.
>  	     */
>  	    if (!profile->first_file) {
> -		profile_release(profile);
> -		return ENOENT;
> +		retval = ENOENT;
> +		goto errout;
>  	    }
>  	}
>  

