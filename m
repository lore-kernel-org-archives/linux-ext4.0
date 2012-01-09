From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: Re: [PATCH 4 4/4] nfsd: vfs_llseek() with 32 or 64 bit offsets (hashes)
Date: Mon, 09 Jan 2012 14:12:04 +0100
Message-ID: <4F0AE7A4.8020003@itwm.fraunhofer.de>
References: <20120109101628.2218398.94904.stgit@localhost.localdomain> <20120109101649.2218398.23334.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yong.fan-KloliPT79xf2eFz/2MeuCQ@public.gmane.org,
	"J. Bruce Fields" <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	adilger-KloliPT79xf2eFz/2MeuCQ@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120109101649.2218398.23334.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 01/09/2012 11:16 AM, Bernd Schubert wrote:
>   #define NFSD_MAY_BYPASS_GSS		0x400
>   #define NFSD_MAY_READ_IF_EXEC		0x800
>
> +#define NFSD_MAY_64BIT_COOKIE	2048 /* 64 bit readdir cookies for>= NFSv3 */
> +

Oh, I just notice the format of the flags has been updated in the mean 
time and the value for NFSD_MAY_64BIT_COOKIE needs to be increased to 
avoid an conflict.
Will send a new series in a moment.

Sorry for not noticing it earlier,
Bernd

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
