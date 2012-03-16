From: Bernd Schubert <bernd.schubert-97jfqw80gc6171pxa8y+qA@public.gmane.org>
Subject: Re: [PATCH 5 3/4] nfsd_open(): rename 'int access' to 'int may_flags'
 in nfsd_open()
Date: Fri, 16 Mar 2012 22:22:51 +0100
Message-ID: <4F63AF2B.5080307@fastmail.fm>
References: <20120309205148.GB5635@thunk.org> <20120312150912.GB12440@thunk.org> <20120312154921.GB17153@pad.fieldses.org> <20120312222250.GD8991@fieldses.org> <20120313200117.GA21991@fieldses.org> <4F5FA827.8020606@itwm.fraunhofer.de> <20120313203446.GB21991@fieldses.org> <4F5FB771.9010805@fastmail.fm> <20120313212947.GK31995@pad.fieldses.org> <4F60AC0D.9020204@itwm.fraunhofer.de> <20120314160529.GB31194@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>,
	"J. Bruce Fields" <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yong.fan-KloliPT79xf2eFz/2MeuCQ@public.gmane.org,
	sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adilger-KloliPT79xf2eFz/2MeuCQ@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120314160529.GB31194-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 03/14/2012 05:05 PM, J. Bruce Fields wrote:
> On Wed, Mar 14, 2012 at 03:32:45PM +0100, Bernd Schubert wrote:
>> shall I sent an updated version of the previous ext4 patch
>> or is this patch sufficient?
>
> Up to Ted.
>
> Ted, I haven't published my merge of your branch, so at least for my
> purposes I don't care whether you fold this in or pop another patch on
> top.

Ted, could you please tell me how to proceed?


Thanks,
Bernd
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
