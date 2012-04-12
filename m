From: Bernd Schubert <bernd.schubert-97jfqw80gc6171pxa8y+qA@public.gmane.org>
Subject: Re: [PATCH 5 3/4] nfsd_open(): rename 'int access' to 'int may_flags'
 in nfsd_open()
Date: Thu, 12 Apr 2012 23:22:41 +0200
Message-ID: <4F8747A1.8060800@fastmail.fm>
References: <20120309205148.GB5635@thunk.org> <20120312150912.GB12440@thunk.org> <20120312154921.GB17153@pad.fieldses.org> <20120312222250.GD8991@fieldses.org> <20120313200117.GA21991@fieldses.org> <4F5FA827.8020606@itwm.fraunhofer.de> <20120313203446.GB21991@fieldses.org> <4F5FB771.9010805@fastmail.fm> <20120313212947.GK31995@pad.fieldses.org> <4F60AC0D.9020204@itwm.fraunhofer.de> <20120412204948.GE6667@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>,
	"J. Bruce Fields" <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
	Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	yong.fan-KloliPT79xf2eFz/2MeuCQ@public.gmane.org, sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adilger-KloliPT79xf2eFz/2MeuCQ@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120412204948.GE6667-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 04/12/2012 10:49 PM, J. Bruce Fields wrote:
> On Wed, Mar 14, 2012 at 03:32:45PM +0100, Bernd Schubert wrote:
>> On 03/13/2012 10:29 PM, J. Bruce Fields wrote:
>>> On Tue, Mar 13, 2012 at 10:09:05PM +0100, Bernd Schubert wrote:
>>>> Hmm, there must have gone something wrong on merging,
>>>
>>> In that case one approach would be to rebase your last-sent patches on
>>> to the same base as Ted's versions, confirm that one still works and the
>>> other doesn't, and do a diff....
>>>
>>>> my own test
>>>> also fails
>>>>
>>>> http://www.pci.uni-heidelberg.de/tc/usr/bernd/downloads/test_seekdir/
>>>>
>>>> (Sorry, it does not say 'failure', but one needs to compare the file
>>>> names and telldir-offset numbers)
>>>>
>>>> I think I will continue in the morning as its already 1 a.m. here.
>>>
>>> OK, thanks for following up!
> 
> Stupid question: is there any fundamental feature of ext4 this depends
> on, or would this fix work equally well for fs/ext3?

First of all, Bruce and Ted, thanks a lot for your patience with those
patches!

I have not looked into it in detail yet, but it should be possible to
back port it to ext3. I don't think there is anything that would depend
on ext4. I also have ext3 on my todo list, but I first wanted to have it
in ext4 (in the sense of stability of ext3, if there still should be a
bug...) and I think for 3.4 it is too late now anyways. So unless there
are objections, lets target the back port to ext3 for 3.5?


Cheers,
Bernd
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
