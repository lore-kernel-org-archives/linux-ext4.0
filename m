From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Patch adding e2p_feature_to_string
Date: Wed, 17 Dec 2014 13:30:28 -0700
Message-ID: <7EB7C92E-036C-4460-A132-344C06F83336@dilger.ca>
References: <CAC80aehVQyWfkd6X339n2bhkDU574hTMWEKXcxzeJrwP4K8E+A@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?Q?=F0=9F=91=BE_Wade?= <wadetregaskis@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44057 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaLQUab convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Dec 2014 15:30:31 -0500
Received: by mail-pa0-f48.google.com with SMTP id rd3so17043813pab.7
        for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2014 12:30:30 -0800 (PST)
In-Reply-To: <CAC80aehVQyWfkd6X339n2bhkDU574hTMWEKXcxzeJrwP4K8E+A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 17, 2014, at 12:27 PM, Wade <wadetregaskis@google.com> wrote:
> 
> This is needed to provide a version of e2p_feature2string that doesn't
> use (and return a pointer to) an internal, static buffer.

What's wrong with a pointer to a static string?  Since the strings are
static, none of the callers can change them.  Since they are just pointers,
they can be shared by any number of callers.

More inline below.

> diff --git a/lib/e2p/e2p.h b/lib/e2p/e2p.h
> index 5fa41f4..53f0183 100644
> --- a/lib/e2p/e2p.h
> +++ b/lib/e2p/e2p.h
> @@ -45,6 +45,8 @@ void print_fs_state (FILE * f, unsigned short state);
> int setflags (int fd, unsigned long flags);
> int setversion (int fd, unsigned long version);
> 
> +void e2p_feature_to_string(int compat, unsigned int mask, char *buf,
> +                          size_t buf_len);
> const char *e2p_feature2string(int compat, unsigned int mask);
> const char *e2p_jrnl_feature2string(int compat, unsigned int mask);
> int e2p_string2feature(char *string, int *compat, unsigned int *mask);
> diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
> index 6e53cfe..6dca315 100644
> --- a/lib/e2p/feature.c
> +++ b/lib/e2p/feature.c
> @@ -117,17 +117,20 @@ static struct feature jrnl_feature_list[] = {
>        {       0, 0, 0 },
> };
> 
> -const char *e2p_feature2string(int compat, unsigned int mask)
> +void e2p_feature_to_string(int compat, unsigned int mask, char *buf,
> +                           size_t buf_len)
> {
>        struct feature  *f;
> -       static char buf[20];
>        char    fchar;
>        int     fnum;
> 
>        for (f = feature_list; f->string; f++) {
>                if ((compat == f->compat) &&
> -                   (mask == f->mask))
> -                       return f->string;
> +                   (mask == f->mask)) {
> +                       strncpy(buf, f->string, buf_len);
> +                       buf[buf_len - 1] = 0;
> +                       return;
> +                }
>        }

This adds a strncpy() for every caller, even when it isn't necessary
for callers that only want the existing e2p_feature2string() function.

>        switch (compat) {
>        case  E2P_FEATURE_COMPAT:
> @@ -144,7 +147,13 @@ const char *e2p_feature2string(int compat,
> unsigned int mask)
>                break;
>        }
>        for (fnum = 0; mask >>= 1; fnum++);
> -       sprintf(buf, "FEATURE_%c%d", fchar, fnum);
> +       snprintf(buf, buf_len, "FEATURE_%c%d", fchar, fnum);
> +}
> +
> +const char *e2p_feature2string(int compat, unsigned int mask)
> +{
> +       static char buf[20];
> +       e2p_feature_to_string(compat, mask, buf, sizeof(buf) / sizeof(buf[0]));

This is copying into a single shared buffer for all callers, which is
not thread safe.


A better approach would be to make e2p_feature_to_string() (or maybe
a better name like e2p_feature_string_copy() that distinguishes it
from the existing function) call e2p_feature2string() internally so
the copy is only in the function where it is needed:

char *e2p_feature_string_copy(int compat, unsigned int mask, char *buf,
			      size_t buf_len)
{
        const char *feature = e2p_feature2string(compat, mask);

        strncpy(buf, feature, buf_len);
        buf[buf_len - 1] = '\0';

        return buf;        
}

Note that this version also returns "buf" since this can be convenient
for the caller in some cases, and doesn't hurt.


Cheers, Andreas





