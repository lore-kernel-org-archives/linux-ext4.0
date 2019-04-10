Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07290C10F11
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 10:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8AFF20850
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 10:11:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="Idb9bvqk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbfDJKLf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 10 Apr 2019 06:11:35 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33540 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbfDJKLe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Apr 2019 06:11:34 -0400
Received: by mail-pf1-f196.google.com with SMTP id h5so1202372pfo.0
        for <linux-ext4@vger.kernel.org>; Wed, 10 Apr 2019 03:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=/E0jlroL4WYRFrHcOv/053PBnouyfLGJIwVU37BaPUk=;
        b=Idb9bvqkzYAA3U3JvRnV/PiAvyFG1FH18G3eXzJhba/uu14cvKu3p9ytH9C1rxuRDr
         9PGZ+LtQjSFgZrrNamkJ33kqpaYDoDuf0DwUO88RHGZXKvxM91+1+E1BSf+ZwWnmzEmI
         foiHAlK+7D4dQwT8A7qkHk6GLonK9BImawQ9UNiH+cDYMfrPwBFeSLymnssyvLZjzVC6
         eH3wRqYyqXPKzxmshKMlvr/Hr0B3NIZG+xaW68mQl+TsZZsjjYYrenYU8e9AM97KBKru
         NmdUeEBMYNoBPPHFB6ln7A1poB25QVzdvw7o9Jm0zrBE6JzWh7CHM6jrkxVqOi0vR38t
         jnww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/E0jlroL4WYRFrHcOv/053PBnouyfLGJIwVU37BaPUk=;
        b=bUhvd1pOgu/20XprB9V72CHS+BXeobJjxabprmYh2QalZoSYpvvqdMEsBW4i5Oya3R
         LQYADckUdhhTdkYrePHLowmEiE4cfJKS9V92D0XNkiyY5hd+BYMUaXZZ6xAf1fy5iyW3
         Od4k6sNslInenyi2OZyTQXpZI750CFPD7CRtwb7D2D8l6oQmc9QKAJhPmqXHrZXpHVKY
         NxsucjLql2KuphicaLdoDatbIvJM0ZcrpLK4AIgPh+yX9E3uG17Xn375BI55fgf9JfcZ
         taEmIvP3NmuhEQivcH0FgpNfuCKevvjYZIgz1SFAE2Hn41CePSKKgbdNRlhwfIU9/ubV
         D6Ag==
X-Gm-Message-State: APjAAAU7mxzdN2pJche9PoekD0NEDG8hy33N0RE+GCBmgpIvHBKLU+JO
        Og3x1cYDs8UIvW+wklEweEb1xg==
X-Google-Smtp-Source: APXvYqxlm1/GFOuZMGbYlZga19K4WhxR/kp3s0bGEHatoNgq3RXABWP+mA1UEdpMKSO4ZfjvGbPDsw==
X-Received: by 2002:a65:62cc:: with SMTP id m12mr39646655pgv.118.1554891093706;
        Wed, 10 Apr 2019 03:11:33 -0700 (PDT)
Received: from [10.92.144.180] ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id m7sm50271097pgg.62.2019.04.10.03.11.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Apr 2019 03:11:33 -0700 (PDT)
Subject: Re: [External Email] Re: [PATCH v2] fiemap : add fiemap misc tool
To:     Karel Zak <kzak@redhat.com>
Cc:     Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        util-linux@vger.kernel.org
References: <1554883940-19963-1-git-send-email-pizhenwei@bytedance.com>
 <20190410095947.y6bfinzhrqtprpvz@ws.net.home>
From:   zhenwei pi <pizhenwei@bytedance.com>
Message-ID: <844a45bf-cea0-014b-9cdf-4cfdfb9c4f48@bytedance.com>
Date:   Wed, 10 Apr 2019 18:11:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190410095947.y6bfinzhrqtprpvz@ws.net.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 04/10/2019 05:59 PM, Karel Zak wrote:

> On Wed, Apr 10, 2019 at 04:12:20PM +0800, zhenwei pi wrote:
>> Add fiemap to dump file extent mappings. Typically we can recognize a
>> file is sparse or not.
> It's good idea to export FIEMAP to command line, but it seems we
> already have xfs_io and filefrag.
>
> The command filefrag seems pretty usable and with "-e" it provides
> exactly the same output like your "fiemap" tool.
>
> The problem I see is that filefrag is in e2fsprogs package. It would
> be better to have it in some more generic package and FS independent
> package.
>
> Maybe we can do another move from e2fsprogs to util-linux. Ted, your
> opinion?
>
>      Karel

I did't know "filefrag -e". There is no need to re-write the same tool.
Thanks.

	zhenwei pi

>
> # filefrag -e /var/log/wtmp
> Filesystem type is: ef53
> File size of /var/log/wtmp is 9032064 (2206 blocks of 4096 bytes)
>   ext:     logical_offset:        physical_offset: length:   expected: flags:
>     0:        0..       0:   11567426..  11567426:      1:
>     1:        1..     190:   11730944..  11731133:    190:   11567427:
>     2:      191..     380:   11732109..  11732298:    190:   11731134:
>     3:      381..     570:   11731883..  11732072:    190:   11732299:
>     4:      571..     633:   11731501..  11731563:     63:   11732073:
>     5:      634..     761:   11731584..  11731711:    128:   11731564:
>     6:      762..     763:   11731198..  11731199:      2:   11731712:
>     7:      764..     764:   11732073..  11732073:      1:   11731200:
>     8:      765..     955:   11731200..  11731390:    191:   11732074:
>     9:      956..    1145:   11732705..  11732894:    190:   11731391:
>    10:     1146..    1254:   11733137..  11733245:    109:   11732895:
>    11:     1255..    1444:   11732895..  11733084:    190:   11733246:
>    12:     1445..    1824:   11733246..  11733625:    380:   11733085:
>    13:     1825..    2014:   11737497..  11737686:    190:   11733626:
>    14:     2015..    2205:   11896890..  11897080:    191:   11737687: last,eof
> /var/log/wtmp: 15 extents found
>
>
>> For example:
>>   #./fiemap /var/log/syslog /var/log/syslog.2.gz
>> File /var/log/syslog has 19 extent(s):
>>    	Logical          Physical         Length           Flag
>> 0:	0000000000000000 00000010d63a8000 0000000000001000 0000
>> 1:	0000000000001000 00000010d63c4000 0000000000001000 0000
>> 2:	0000000000002000 00000010d63d6000 0000000000001000 0000
>> 3:	0000000000003000 00000010d723e000 0000000000001000 0000
>> 4:	0000000000004000 000000076c377000 0000000000001000 0000
>> 5:	0000000000005000 00000010d550f000 0000000000001000 0000
>> 6:	0000000000006000 00000010d7290000 0000000000001000 0000
>> 7:	0000000000007000 00000010d57c9000 0000000000001000 0000
>> 8:	0000000000008000 00000010d57f5000 0000000000001000 0000
>> 9:	0000000000009000 000000076d6b3000 0000000000001000 0000
>> 10:	000000000000a000 00000010d558d000 0000000000001000 0000
>> 11:	000000000000b000 00000010d77ff000 0000000000001000 0000
>> 12:	000000000000c000 00000010d67fb000 0000000000001000 0000
>> 13:	000000000000d000 00000010d73fc000 0000000000001000 0000
>> 14:	000000000000e000 00000005d2bb2000 0000000000001000 0000
>> 15:	000000000000f000 00000007705a1000 0000000000001000 0000
>> 16:	0000000000010000 0000000c8bf10000 0000000000010000 0000
>> 17:	0000000000020000 0000001070020000 0000000000060000 0000
>> 18:	0000000000080000 00000011aa580000 0000000000014000 0001
>>
>> File /var/log/syslog.2.gz has 1 extent(s):
>>    	Logical          Physical         Length           Flag
>> 0:	0000000000000000 0000000995c40000 0000000000023000 0001
>>
>> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
>> ---
>>   AUTHORS                  |   1 +
>>   configure.ac             |   3 +
>>   misc-utils/Makemodule.am |   5 ++
>>   misc-utils/fiemap.c      | 155 +++++++++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 164 insertions(+)
>>   create mode 100644 misc-utils/fiemap.c
>>
>> diff --git a/AUTHORS b/AUTHORS
>> index d7dbbd6..a0cecf7 100644
>> --- a/AUTHORS
>> +++ b/AUTHORS
>> @@ -20,6 +20,7 @@ AUTHORS (merged projects & commands):
>>         fallocate:       Eric Sandeen <sandeen@redhat.com>
>>                          Karel Zak <kzak@redhat.com>
>>                          Matěj Cepl <mcepl@redhat.com>
>> +      fiemap:          zhenwei pi <pizhenwei@bytedance.com>
>>         fincore:         Masatake YAMATO <yamato@redhat.com>
>>         findmnt:         Karel Zak <kzak@redhat.com>
>>         flock:           H. Peter Anvin <hpa@zytor.com>
>> diff --git a/configure.ac b/configure.ac
>> index bbf07db..ccb1a12 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -1769,6 +1769,9 @@ UL_REQUIRES_LINUX([fincore])
>>   UL_REQUIRES_BUILD([fincore], [libsmartcols])
>>   AM_CONDITIONAL([BUILD_FINCORE], [test "x$build_fincore" = xyes])
>>   
>> +UL_BUILD_INIT([fiemap], [yes])
>> +AM_CONDITIONAL([BUILD_FIEMAP], [test "x$build_fiemap" = xyes])
>> +
>>   UL_BUILD_INIT([fsfreeze], [check])
>>   UL_REQUIRES_LINUX([fsfreeze])
>>   AM_CONDITIONAL([BUILD_FSFREEZE], [test "x$build_fsfreeze" = xyes])
>> diff --git a/misc-utils/Makemodule.am b/misc-utils/Makemodule.am
>> index f56a819..8bdc6fa 100644
>> --- a/misc-utils/Makemodule.am
>> +++ b/misc-utils/Makemodule.am
>> @@ -228,3 +228,8 @@ hardlink_CFLAGS += $(PCRE_CFLAGS)
>>   endif
>>   dist_man_MANS += misc-utils/hardlink.1
>>   endif
>> +
>> +if BUILD_FIEMAP
>> +usrbin_exec_PROGRAMS += fiemap
>> +fiemap_SOURCES = misc-utils/fiemap.c
>> +endif
>> diff --git a/misc-utils/fiemap.c b/misc-utils/fiemap.c
>> new file mode 100644
>> index 0000000..b77eb14
>> --- /dev/null
>> +++ b/misc-utils/fiemap.c
>> @@ -0,0 +1,155 @@
>> +/*
>> + * Copyright (C) 2019 zhenwei pi <pizhenwei@bytedance.com>
>> + *
>> + * This file may be redistributed under the terms of the GNU Public
>> + * License.
>> + */
>> +#include <stdlib.h>
>> +#include <stdio.h>
>> +#include <string.h>
>> +#include <unistd.h>
>> +#include <fcntl.h>
>> +#include <getopt.h>
>> +#include <sys/ioctl.h>
>> +#include <linux/fs.h>
>> +
>> +#include "c.h"
>> +#include "nls.h"
>> +#include "closestream.h"
>> +
>> +#ifdef FS_IOC_FIEMAP
>> +#include <linux/fiemap.h>
>> +
>> +static struct fiemap *read_fiemap(int fd)
>> +{
>> +	struct fiemap *fiemap;
>> +	int extents_size;
>> +
>> +	fiemap = (struct fiemap *)malloc(sizeof(struct fiemap));
>> +	if (fiemap == NULL)
>> +		err(EXIT_FAILURE, _("malloc"));
>> +
>> +	memset(fiemap, 0, sizeof(struct fiemap));
>> +
>> +	fiemap->fm_start = 0;
>> +	fiemap->fm_length = ~0;
>> +	fiemap->fm_flags = 0;
>> +	fiemap->fm_extent_count = 0;
>> +	fiemap->fm_mapped_extents = 0;
>> +
>> +	/* count how many extents there are */
>> +	if (ioctl(fd, FS_IOC_FIEMAP, fiemap) < 0)
>> +		err(EXIT_FAILURE, _("fiemap ioctl() failed"));
>> +
>> +	/* read in the extents */
>> +	extents_size = sizeof(struct fiemap_extent) *
>> +		(fiemap->fm_mapped_extents);
>> +
>> +	/* resize fiemaps for all extents */
>> +	fiemap = (struct fiemap *)realloc(fiemap, sizeof(struct fiemap) +
>> +			extents_size);
>> +	if (fiemap == NULL)
>> +		err(EXIT_FAILURE, _("realloc for extents memory"));
>> +
>> +	memset(fiemap->fm_extents, 0, extents_size);
>> +	fiemap->fm_extent_count = fiemap->fm_mapped_extents;
>> +	fiemap->fm_mapped_extents = 0;
>> +
>> +	if (ioctl(fd, FS_IOC_FIEMAP, fiemap) < 0) {
>> +		err(EXIT_FAILURE, _("ioctl() FS_IOC_FIEMAP failed"));
>> +		return NULL;
>> +	}
>> +
>> +	return fiemap;
>> +}
>> +
>> +static void show_fiemap(struct fiemap *fiemap, char *filename)
>> +{
>> +	unsigned int i = 0;
>> +
>> +	printf("File %s has %d extent(s):\n", filename,
>> +			fiemap->fm_mapped_extents);
>> +	printf("#\tLogical          Physical         Length           Flag\n");
>> +	for (i = 0; i < fiemap->fm_mapped_extents; i++) {
>> +		printf("%d:\t%-16.16llx %-16.16llx %-16.16llx %-4.4x\n", i,
>> +				fiemap->fm_extents[i].fe_logical,
>> +				fiemap->fm_extents[i].fe_physical,
>> +				fiemap->fm_extents[i].fe_length,
>> +				fiemap->fm_extents[i].fe_flags);
>> +	}
>> +
>> +	printf("\n");
>> +}
>> +
>> +static void __attribute__((__noreturn__)) usage(void)
>> +{
>> +	FILE *out = stdout;
>> +
>> +	fputs(USAGE_HEADER, out);
>> +	fprintf(out, _(" %s <file>...\n"), program_invocation_short_name);
>> +
>> +	fputs(USAGE_SEPARATOR, out);
>> +	exit(EXIT_SUCCESS);
>> +}
>> +
>> +int main(int argc, char **argv)
>> +{
>> +	int c;
>> +	static const struct option longopts[] = {
>> +		{ "version",    no_argument, NULL, 'V' },
>> +		{ "help",       no_argument, NULL, 'h' },
>> +		{ NULL, 0, NULL, 0 },
>> +	};
>> +
>> +	setlocale(LC_ALL, "");
>> +	bindtextdomain(PACKAGE, LOCALEDIR);
>> +	textdomain(PACKAGE);
>> +	atexit(close_stdout);
>> +
>> +	while ((c = getopt_long (argc, argv, "Vh", longopts, NULL)) != -1) {
>> +		switch (c) {
>> +		case 'V':
>> +			printf(UTIL_LINUX_VERSION);
>> +			return EXIT_SUCCESS;
>> +
>> +		case 'h':
>> +			usage();
>> +
>> +		default:
>> +			errtryhelp(EXIT_FAILURE);
>> +		}
>> +	}
>> +
>> +	if (optind == argc) {
>> +		warnx(_("no file specified"));
>> +		errtryhelp(EXIT_FAILURE);
>> +	}
>> +
>> +	for ( ; optind < argc; optind++) {
>> +		int fd = 0;
>> +
>> +		fd = open(argv[optind], O_RDONLY);
>> +		if (fd < 0) {
>> +			err(EXIT_FAILURE, _("open file failed"));
>> +		} else {
>> +			struct fiemap *fiemap = NULL;
>> +
>> +			fiemap = read_fiemap(fd);
>> +			if (fiemap != NULL) {
>> +				show_fiemap(fiemap, argv[optind]);
>> +				free(fiemap);
>> +			}
>> +			close(fd);
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +#else
>> +int main(int argc, char **argv)
>> +{
>> +	err(EXIT_FAILURE, _("FS_IOC_FIEMAP not supported"));
>> +
>> +	return 0;
>> +}
>> +#endif
>> -- 
>> 2.7.4
>>

-- 
Thanks and Best Regards,
zhenwei pi

