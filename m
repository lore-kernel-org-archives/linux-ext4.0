From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH RFC v2 2/6] fs: protected project id
Date: Tue, 10 Mar 2015 21:51:59 +0300
Message-ID: <CALYGNiP0u51JVtAROdNpK5hYKHrtpT1WSyKS_tqxsTKZ7FWKvw@mail.gmail.com>
References: <20150310171133.23081.49616.stgit@buzz>
	<20150310172206.23081.95005.stgit@buzz>
	<CALCETrXE99fA1kwiXQvL0oTGZXa-nUwKdQ6_GfUPqXjOq8q0ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Li Xi <pkuelelixi@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXE99fA1kwiXQvL0oTGZXa-nUwKdQ6_GfUPqXjOq8q0ZA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 10, 2015 at 8:32 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Mar 10, 2015 at 10:22 AM, Konstantin Khlebnikov
> <khlebnikov@yandex-team.ru> wrote:
>> Historically XFS project id doesn't have any permission control: file owner
>> is able to set any project id. Later they was sealed with user-namespace:
>> XFS allows to change it only from init user-ns. That works fine for isolated
>> containers or if user doesn't have direct access to the filesystem (NFS/FTP).
>>
>> This patch adds sysctl fs.protected_projects which makes changing project id
>> privileged operation which requires CAP_SYS_RESOURCE in current user-namespace.
>> Thus there are two levels of protection: project id mapping in user-ns defines
>> set of permitted projects and capability protects operations within this set.
>
> If I understand this right, this doesn't work.  If I lack
> CAP_SYS_RESOURCE but I have two projids mapped, then I can create a
> new userns, map both projids, and get CAP_SYS_RESOURCE.

Setting project id mapping for nested user-namespace also requires
this capability in parent namespace. The same as for setting uid/gid
mapping but without special case for mapping current uid/gid because
task has no "current" project id.

This is mentioned in cover letter but I forget it here. Sorry.

>
> --Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
