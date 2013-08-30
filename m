From: Michael Richardson <mcr-SWp7JaYWvAQV+D8aMU/kSg@public.gmane.org>
Subject: Re: [uml-devel] Issues with a rather unusual configured NFS server
Date: Fri, 30 Aug 2013 14:27:08 -0400
Message-ID: <29555.1377887228@sandelman.ca>
References: <52075E01.7030506@gmx.de> <20130812143640.GF4596@quack.suse.cz> <20130813215313.GH17781@fieldses.org> <20130827180655.GE14809@fieldses.org> <521E318C.7040401@gmx.de> <CAFLxGvyK5+nB9TgW1uPho9KGwQrWQHx=wEpj+o-mZcN92bWAOg@mail.gmail.com>
Cc: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster-Mmb7MZpHnFY@public.gmane.org>,
	Linux NFS mailing list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
	"user-mode-linux-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org"
	<user-mode-linux-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>,
	Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	"J. Bruce Fields" <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: richard -rw- weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFLxGvyK5+nB9TgW1uPho9KGwQrWQHx=wEpj+o-mZcN92bWAOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org


richard -rw- weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
    >>>> Thanks for the report.  I think I see the problem--after this commit
    >>>> nfs4_set_delegation() failures result in nfs4_put_delegation being
    >>>> called, but nfs4_put_delegation doesn't free the nfs4_file that has
    >>>> already been set by alloc_init_deleg().
    >>>>
    >>>> Let me think about how to fix that....
    >>>
    >>> Sorry for the slow response--can you check whether this fixes the
    >>> problem?
    >>>
    >> Yes.
    >>
    >> With the attached patch the problem can't be reproduced any longer
    >> with the prepared test case and current git kernels.

    > BTW: Is nobody else fuzz testing NFS?  Or are these bugs just more
    > likely to hit on UML?  This is not the first NFS issue found by Toralf
    > using UML and Trinity.

Kernel thread scheduling is likely very different on UML than other
architectures.

My guess is that there could well be be gaps where no kernel thread is
scheduled (because another process is running), followed by resumption of a
thread other than the one which would have been resumed on other
virtualization.

--
]               Never tell me the odds!                 | ipv6 mesh networks [
]   Michael Richardson, Sandelman Software Works        | network architect  [
]     mcr-SWp7JaYWvAQV+D8aMU/kSg@public.gmane.org  http://www.sandelman.ca/        |   ruby on rails    [

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
