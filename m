From: Austin Schuh <austin-U/e3ovGPoBiXmMXjJBpWqg@public.gmane.org>
Subject: Re: Hang writing to nfs-mounted filesystem from client, all nfsd
 tasks on server blocked in D
Date: Fri, 17 Oct 2014 11:58:00 -0700
Message-ID: <CANGgnMYqgaCDPAr7Q8qx3BW5_w9HsNv-uHcVERphfMxcak7vvg@mail.gmail.com>
References: <544156FE.7070905@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-nfs <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, tytso <tytso-3s7WtUTddSA@public.gmane.org>,
	"adilger.kernel" <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
	rt-users <linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Chris Friesen <chris.friesen-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <544156FE.7070905-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 17, 2014 at 10:50 AM, Chris Friesen
<chris.friesen-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org> wrote:
> Where generic_file_aio_write() is calling mutex_lock(&inode->i_mutex).


Use the 121 patch.  This sounds very similar to the issue that I
helped debug with XFS.  There ended up being a deadlock due to a bug
in the kernel work queues.  You can search the RT archives for more
info.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
