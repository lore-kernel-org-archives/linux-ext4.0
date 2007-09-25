From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: jbd : config_jbd_debug cannot create /proc entry
Date: Tue, 25 Sep 2007 16:34:06 +0530
Message-ID: <46F8EB26.2090104@linux.vnet.ibm.com>
References: <1190713240.3154.20.camel@castor.rsk.org> <20070925105112.GB8126@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: richard kennedy <richard@rsk.demon.co.uk>, sct@redhat.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:42059 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbXIYLEd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 07:04:33 -0400
In-Reply-To: <20070925105112.GB8126@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Jan Kara wrote:
>> 
> -#define create_jbd_proc_entry() do {} while (0)
> -#define remove_jbd_proc_entry() do {} while (0)
> +static ctl_table fs_table[] = {
> +	{
> +                .ctl_name       = -1,	/* Don't want it */



shouldn't this be CTL_UNNUMBERED ?


> +                .procname       = "jbd-debug",
> +                .data           = &journal_enable_debug,
> +                .maxlen         = sizeof(int),
> +                .mode           = 0644,
> +                .proc_handler   = &proc_dointvec,
> +        },
> +        { .ctl_name = 0 },
> +};
>

-aneesh
