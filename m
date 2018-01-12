From: "Weber, Olaf (HPC Data Management & Storage)" <olaf.weber@hpe.com>
Subject: RE: [PATCH RFC 07/13] charsets: utf8: Hook-up utf-8 code to charsets
 library
Date: Fri, 12 Jan 2018 10:38:25 +0000
Message-ID: <DF4PR8401MB0812A452CD9D28F218A731D685170@DF4PR8401MB0812.NAMPRD84.PROD.OUTLOOK.COM>
References: <20180112071234.29470-1-krisman@collabora.co.uk>
 <20180112071234.29470-8-krisman@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "kernel@lists.collabora.co.uk" <kernel@lists.collabora.co.uk>,
        "alvaro.soliverez@collabora.co.uk" <alvaro.soliverez@collabora.co.uk>
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "david@fromorbit.com" <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20180112071234.29470-8-krisman@collabora.co.uk>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Gabriel,

A couple of comments inline below.

Olaf Weber

> -----Original Message-----
> From: Gabriel Krisman Bertazi [mailto:krisman@collabora.co.uk]
> Sent: Friday, January 12, 2018 08:12
> To: tytso@mit.edu; david@fromorbit.com; bpm@sgi.com; olaf@sgi.com
> Cc: linux-ext4@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> kernel@lists.collabora.co.uk; alvaro.soliverez@collabora.co.uk; Gabriel
> Krisman Bertazi <krisman@collabora.co.uk>
> Subject: [PATCH RFC 07/13] charsets: utf8: Hook-up utf-8 code to charsets
> library
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
> ---
>  lib/charsets/Makefile    |   2 +-
>  lib/charsets/utf8_core.c | 178
> +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 179 insertions(+), 1 deletion(-)
>  create mode 100644 lib/charsets/utf8_core.c
> 
> diff --git a/lib/charsets/Makefile b/lib/charsets/Makefile
> index 95389c4193b0..5e2fa7c20a47 100644
> --- a/lib/charsets/Makefile
> +++ b/lib/charsets/Makefile
> @@ -4,7 +4,7 @@ obj-$(CONFIG_CHARSETS) += charsets.o
> 
>  obj-$(CONFIG_CHARSETS) += ascii.o
> 
> -utf8-y += utf8norm.o
> +utf8-y += utf8_core.o utf8norm.o
>  obj-$(CONFIG_UTF8_NORMALIZATION) +=  utf8.o
> 
>  $(obj)/utf8norm.o: $(obj)/utf8data.h
> diff --git a/lib/charsets/utf8_core.c b/lib/charsets/utf8_core.c
> new file mode 100644
> index 000000000000..94427670e96e
> --- /dev/null
> +++ b/lib/charsets/utf8_core.c
> @@ -0,0 +1,178 @@
> +/*
> + * Copyright (c) 2017 Collabora Ltd.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/charsets.h>
> +#include <linux/utf8norm.h>
> +#include <linux/slab.h>
> +#include <linux/parser.h>
> +#include <linux/string.h>
> +
> +static int utf8_strncmp(const struct charset *charset, const char *str1,
> +			const char *str2, int len)
> +{
> +	const struct utf8data *data = utf8nfkdi(charset->version);
> +	struct utf8cursor cur1, cur2;
> +	unsigned char c1, c2;
> +	int r, i;
> +
> +	r = utf8cursor(&cur1, data, str1);
> +	if (r < 0)
> +		return -EIO;
> +	r = utf8cursor(&cur2, data, str2);
> +	if (r < 0)
> +		return -EIO;
> +
> +	for (i = 0 ; i < len ; i++) {
> +		c1 = utf8byte(&cur1);
> +		c2 = utf8byte(&cur2);
> +
> +		if (!c1 || !c2 || c1 != c2)
> +			return 1;
> +
> +	}
> +
> +	return 0;
> +}

This function is broken, but the reasons why illustrate the traps and pitfalls of working
with utf8 code and limited length buffers.

As written, if str1 or str2 doesn't trip the len check, then utf8_strncmp() returns 1 (not equal).
It does this even if the strings are equal. The check in the loop would have to be something
like this instead:
		if (c1 != c2)
			return 1;
		if (!c1) /* implies !c2 as well */
			return 0;

But this is not the only problem. The 'len' limit applies to the input strings. So you need to tell
the utf8byte() routine that it applies. In other words, use utf8ncursor() which takes an additional
length parameter to set up the cursors.

With this change, utf8byte() will return 0 when it hits the end of the input string due to seeing a
null byte or having consumed all characters, provided that it is not in the middle of a utf8 sequence
or a an incomplete sequence of Unicode characters.

Finally, note that utf8byte() returns an int, not a char. It does this for the same reasons getc() does.

So utf8_strncmp() becomes something like the following. I'm using EINVAL instead of EIO, and note
that -EINVAL does not imply that str1 and str2 are not equal when compared as a sequence of bytes.

static int utf8_strncmp(const struct charset *charset,
			const char *str1,
			const char *str2,
			int len)
{
	const struct utf8data *data = utf8nfkdi(charset->version);
	struct utf8cursor cur1;
	struct utf8cursor cur2;
	int c1;
	int c2;

	if (utf8ncursor(&cur1, data, str1, len) < 0)
		return -EINVAL;
	if (utf8ncursor(&cur2, data, str2, len) < 0)
		return -EINVAL;

	do {
		c1 = utf8byte(&cur1);
		c2 = utf8byte(&cur2);

		if (c1 < 0 || c2 < 0)
			return -EINVAL;
		if (c1 != c2)
			return 1;
	} while (c1);

	return 0;
}


> +
> +static int utf8_strncasecmp(const struct charset *charset, const char *str1,
> +			    const char *str2, int len)
> +{
> +	const struct utf8data *data = utf8nfkdicf(charset->version);
> +	struct utf8cursor cur1, cur2;
> +	unsigned char c1, c2;
> +	int r, i;
> +
> +	r = utf8cursor(&cur1, data, str1);
> +	if (r < 0)
> +		return -EIO;
> +
> +	r = utf8cursor(&cur2, data, str2);
> +	if (r < 0)
> +		return -EIO;
> +
> +	for (i = 0 ; i < len ; i++) {
> +		c1 = utf8byte(&cur1);
> +		c2 = utf8byte(&cur2);
> +
> +		if (!c1 || !c2 || c1 != c2)
> +			return 1;
> +	}
> +
> +	return 0;
> +}

Same comments as above apply here.

> +
> +int utf8_casefold(const struct charset *charset, const char *str, int len,
> +		  char **folded_str)
> +{
> +	const struct utf8data *data = utf8nfkdicf(charset->version);
> +	struct utf8cursor cur;
> +	int i;
> +	char buffer[1024];
> +
> +	if (utf8cursor(&cur, data, str))
> +		return -EIO;
> +
> +	for (i = 0; i < (1024-1); i++) {
> +		buffer[i] = utf8byte(&cur);
> +		if (!buffer[i])
> +			break;
> +	}
> +	buffer[i] = '\0';
> +	*folded_str = kstrdup(buffer, GFP_NOFS);
> +	if (!*folded_str)
> +		return -ENOMEM;
> +
> +	return i;
> +}

I'm not sure a 1 buffer on the stack will be welcome. Maybe just use
utf8nlen() to get the target size and eat the cost of doing the normalization
twice. An advantage of using utf8nlen() is that it will validate the input string
as well.

Here too you should use utf8ncursor() to account for the len parameter. 

int utf8_casefold(const struct charset *charset,
		const char *str, int len,
		char **folded_str)
{
	const struct utf8data *data = utf8nfkdicf(charset->version);
	struct utf8cursor cur;
	char *s;
	int c;
	ssize_t size;

	size = utf8nlen(data, str, len);
	if (size < 0)
		return -EINVAL;
	s = kmalloc(size + 1, GFP_NOFS);
	if (!s)
		return -ENOMEM;
	*folded_string = s;
	/*
	 * utf8nlen() verified that str is well-formed, so
	 * utf8ncursor() and utf8byte() will not fail.
	 */
	utf8ncursor(&cur, data, str, len);
	do {
		c = utf8byte(&cur);
		*s++ = c;
	} while (c);

	return size;
}

The do-while loop could be written as follows as well, but IIRC that style is discouraged these days.

	while ((*s++ = utf8byte(&cur))
		;


> +
> +int utf8_normalize(const struct charset *charset, const char *str, int len,
> +		   char **normalization)
> +{
> +	const struct utf8data *data = utf8nfkdi(charset->version);
> +	struct utf8cursor cur;
> +	int i;
> +	char buffer[1024];
> +
> +	if (utf8cursor(&cur, data, str))
> +		return -EIO;
> +
> +	for (i = 0; i < (1024-1); i++) {
> +		buffer[i] = utf8byte(&cur);
> +		if (!buffer[i])
> +			break;
> +	}
> +	buffer[i] = '\0';
> +	*normalization = kstrdup(buffer, GFP_NOFS);
> +	if (!*normalization)
> +		return -ENOMEM;
> +
> +	return i;
> +}

Similar here.

> +
> +static const struct charset_ops utf8_ops = {
> +	.strncmp = utf8_strncmp,
> +	.strncasecmp = utf8_strncasecmp,
> +	.casefold = utf8_casefold,
> +	.normalize = utf8_normalize,
> +};
> +
> +static struct charset *utf8_load_charset(void *pargs)
> +{
> +	int maj, min, rev;
> +	unsigned int age;
> +	struct charset *charset;
> +	substring_t *args = pargs;
> +
> +	if (match_int(&args[0], &maj) || match_int(&args[1], &min) ||
> +	    match_int(&args[2], &rev))
> +		return NULL;
> +
> +	age = UNICODE_AGE(maj, min, rev);
> +
> +	if (!utf8version_is_supported(age))
> +		return NULL;

Maybe utf8version_is_supported() should be changed to take 'maj', 'min', 'rev' as separate parameters.

Olaf

> +
> +	charset = kmalloc(sizeof(struct charset), GFP_KERNEL);
> +	if (!charset)
> +		return NULL;
> +
> +	charset->info = NULL;
> +	charset->version = age;
> +	charset->ops = &utf8_ops;
> +
> +	return charset;
> +}
> +
> +static struct charset_info utf8_info = {
> +	.name = "utf8",
> +	.match_token = "utf8-%d.%d.%d",
> +	.load_charset = utf8_load_charset,
> +};
> +
> +static int __init init_utf8(void)
> +{
> +	charset_register(&utf8_info);
> +	return 0;
> +}
> +
> +static void __exit exit_utf8(void)
> +{
> +}
> +
> +module_init(init_utf8);
> +module_exit(exit_utf8);
> +MODULE_AUTHOR("Gabriel Krisman Bertazi");
> +MODULE_DESCRIPTION("UTF-8 charset operations for filesystems");
> +MODULE_LICENSE("GPL");
> +
> --
> 2.15.1
