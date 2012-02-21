From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: check new sysfs interface to determine if we
 are on battery
Date: Mon, 20 Feb 2012 18:17:38 -0600
Message-ID: <4F42E2A2.1020703@redhat.com>
References: <1329783103-4017-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab2BUARn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Feb 2012 19:17:43 -0500
In-Reply-To: <1329783103-4017-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/20/12 6:11 PM, Theodore Ts'o wrote:
> ...since the old way is deprecated.
> 
> Addresses-SourceForge-Bug: #3439277

Red Hat bug #644629 too

But https://bugzilla.redhat.com/show_bug.cgi?id=644629#c5
made it sound harder than this, so I was ... keeping that bug
on the back burner ...

> You need to enumerate through all power supply devices with the "type" =
> "Mains" attribute, and check if any of them have the "online" attribute as "1".
> If so you have AC power. If don't find any power supply of "type" = "Mains"
> then you are on AC power too. Only if you have one or more power supplies of
> "type" = "Mains" and all of them have "online" = "0" then you are on battery.

If your patch fixes the general case, I say go for it! :)

-Eric

> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  e2fsck/unix.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index c38b67a..6f97b0f 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -252,6 +252,14 @@ static int is_on_batt(void)
>  	unsigned int	acflag;
>  	struct dirent*	de;
>  
> +	f = fopen("/sys/class/power_supply/AC/online", "r");
> +	if (f) {
> +		if (fscanf(f, "%d\n", &acflag) == 1) {
> +			fclose(f);
> +			return (!acflag);
> +		}
> +		fclose(f);
> +	}
>  	f = fopen("/proc/apm", "r");
>  	if (f) {
>  		if (fscanf(f, "%s %s %s %x", tmp, tmp, tmp, &acflag) != 4)

