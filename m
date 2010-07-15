From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended
	file stats available [ver #6]
Date: Thu, 15 Jul 2010 22:35:22 +0200
Message-ID: <201007152235.22373.arnd@arndb.de>
References: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
	<20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-ext4.vger.kernel.org

On Thursday 15 July 2010 04:17:12 David Howells wrote:
> (10) Can be extended by using more request flags and tagging further data after
>      the end of the standard return data.  Such things as the following could
>      be returned:
> 
>         - BSD st_flags or FS_IOC_GETFLAGS.
>         - Volume ID / Remote Device ID [Steve French].
>         - Time granularity (NFSv4 time_delta) [Steve French].
>         - Mask of features available on file (eg: ACLs, seclabel) [Brad Boyer,
>           Michael Kerrisk].
> 
> This was initially proposed as a set of xattrs, but the general preferance is
> for an extended stat structure.

I don't think I'd call this general preference. Three of the four
are fixed length and could easily be done inside the structure if you
leave a bit of space instead of a variable-length field at the end.

For the volume id, I could not find any file system that requires more
than 32 bytes here, which is also reasonable to put into the structure.
Make it 36 if you want to cover ascii encoded UUIDs.

That's at most 60 bytes for the extensions you're considering already,
plus the 152 you have already is still less than a cache line on
some machines. Padding it to 256 bytes would make it nice and round,
if you want to be really sure, make it 384 bytes.

> The following structures are defined for the use of these new system calls:
> 
>         struct xstat_parameters {
>                 unsigned long long      request_mask;
>         };

I'd also still argue that 32 bits would be better since you can
put them into the argument list instead of having to use a pointer
to xstat_parameters. You only use 15 bits so far, so the remaining
17 bits should go a long way. It's not as important to me as the
previous point though.

> The system calls are:
> 
>         ssize_t ret = xstat(int dfd,
>                             const char *filename,
>                             unsigned flags,
>                             const struct xstat_parameters *params,
>                             struct xstat *buffer,
>                             size_t buflen);

The resulting syscall I'd hope for would be

int xstat(dfd, const char *filename, unsigned flags,
	  unsigned mask, struct xstat *buf);

Everything else in your patch looks very good and has my full support.

	Arnd
