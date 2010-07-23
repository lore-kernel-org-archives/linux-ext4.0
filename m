From: tridge-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
 extended file stats available [ver #6]
Date: Fri, 23 Jul 2010 12:12:47 +1000
Message-ID: <19528.64159.999224.437890@samba.org>
References: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
	<20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
	<30448.1279800887@redhat.com>
	<E1Obuiy-00C9jr-Al@intern.SerNet.DE>
	<AANLkTikBCXK6uEwWq4f0LvpdoKCPs3jvyFa4Zw4e2J_7@mail.gmail.com>
	<E1Obxpd-00CRIo-SF@intern.SerNet.DE>
	<AANLkTimwIq0pBhCeOjOVjB0yeM3JHOvzVoj9M4ui6al9@mail.gmail.com>
	<20100722162712.GB10352@jeremy-laptop>
	<AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com>
	<19528.60019.28495.655512@samba.org>
	<20100723012130.GD16373@thunk.org>
Reply-To: tridge-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100723012130.GD16373-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

 > Does it literally mean "file creation time" in terms of when the OS
 > created the file, or does it mean "file" in the sense of
 > application contents.  For example, if an application edits the
 > file and saves it out using "write file to foo.new; sync; rename
 > foo to foo.bak; rename foo.new to foo", should the creation time
 > for the newly written file "foo" be the time when the editor saved
 > out the file (i.e., when "foo.new" was created), or copied from the
 > original file "foo"'s creation time.

In Windows this is can be controlled by applications, but it also is
done at the filesystem level in NTFS using a technique that Microsoft
call "File System Tunneling". If you create a file with the same name
within a short time (default 15s and settable in the registry) of when
the file previously existed then it will get the same CreationTime as
the previous file.

For details see http://support.microsoft.com/kb/172190

Some applications also do this regardless of the registry setting for
MaximumTunnelEntryAgeInSeconds. They use the ability to set the
CreationTime to get the same behaviour.

Cheers, Tridge
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
