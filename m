From: Jason Pepas <jasonpepas@gmail.com>
Subject: Re: mkfs.ext2 succeeds despite nbd write errors?
Date: Sat, 7 Nov 2015 17:23:46 -0600
Message-ID: <CALuDM+BwJoa+7fYz61WofYzdh=T-WvgJL76OzP3U5sm+m=HKrg@mail.gmail.com>
References: <CALuDM+AtyUUMFcdTOocxCw9BxQ4PBx5aeYVYwmy_UErh1MZjww@mail.gmail.com>
	<20151107110354.GM1908@redhat.com>
	<CALuDM+Aw9JCMVbQcRKaaUu+=+xvDpMgL8sUZpT2snz9Qp5DqpA@mail.gmail.com>
	<20151107210203.GW29330@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=089e0115f052e152690523fba6e9
Cc: linux-ext4@vger.kernel.org, libguestfs@redhat.com
To: "Richard W.M. Jones" <rjones@redhat.com>
Return-path: <libguestfs-bounces@redhat.com>
In-Reply-To: <20151107210203.GW29330@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/libguestfs>,
	<mailto:libguestfs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/libguestfs>
List-Post: <mailto:libguestfs@redhat.com>
List-Help: <mailto:libguestfs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/libguestfs>,
	<mailto:libguestfs-request@redhat.com?subject=subscribe>
Sender: libguestfs-bounces@redhat.com
Errors-To: libguestfs-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

--089e0115f052e152690523fba6e9
Content-Type: text/plain; charset=UTF-8

On Sat, Nov 7, 2015 at 3:02 PM, Richard W.M. Jones <rjones@redhat.com> wrote:
> On Sat, Nov 07, 2015 at 01:22:45PM -0600, Jason Pepas wrote:
>> I did manage to find two calls to fsync in the e2fsprogs source which
>> are not return-value-checked:
>>
>> https://github.com/tytso/e2fsprogs/blob/956b0f18a5ddb6815a9dff4f10a1e3125cdca9ba/misc/filefrag.c#L303
>> https://github.com/tytso/e2fsprogs/blob/956b0f18a5ddb6815a9dff4f10a1e3125cdca9ba/lib/ext2fs/unix_io.c#L915
>
> That second one looks very suspicious to me.  I don't think that it's
> ever right for mke2fs to ignore the return value from an fsync call,
> so assuming mke2fs calls that function it's surely a bug.


I locally patched mke2fs to check the return value of those two
fsync() calls, and now it exits failure like it should:


root@debian:~/mkfs/e2fsprogs-1.42.12/build/misc# strace ./mke2fs
/dev/nbd0 2>&1 | tail
write(1, "\10\10\10\10\1)          = 5
pwrite(3, "\1\2\0\0\2\2\0\0\3\2\0\0\367{\365\37\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
4096, 6576672768) = 4096
fsync(3)                                = -1 EIO (Input/output error)
pwrite(3, "\0\0\10\0\0\0
\0\231\231\1\0qm\37\0\365\377\7\0\0\0\0\0\2\0\0\0\2\0\0\0"..., 1024,
1024) = 1024
fsync(3)                                = -1 EIO (Input/output error)
close(3)                                = 0
write(2, "\nWarning, had trouble writing ou"..., 46
Warning, had trouble writing out superblocks.) = 46
exit_group(5)                           = ?
+++ exited with 5 +++



The patches are pretty simple:


root@debian:~/mkfs# diff -urN e2fsprogs-1.42.12.orig/misc/filefrag.c
e2fsprogs-1.42.12/misc/filefrag.c
--- e2fsprogs-1.42.12.orig/misc/filefrag.c      2014-08-13
14:57:29.000000000 -0500
+++ e2fsprogs-1.42.12/misc/filefrag.c   2015-11-07 13:44:17.089128243 -0600
@@ -292,8 +292,11 @@
                fm_ext.fe_flags = FIEMAP_EXTENT_MERGED;
        }

-       if (sync_file)
-               fsync(fd);
+       if (sync_file) {
+               int rc = fsync(fd);
+               if (rc < 0)
+                       return rc;
+       }

        for (i = 0, logical = 0, *num_extents = 0, count = last_block = 0;
             i < numblocks;
root@debian:~/mkfs# diff -urN
e2fsprogs-1.42.12.orig/lib/ext2fs/unix_io.c
e2fsprogs-1.42.12/lib/ext2fs/unix_io.c
--- e2fsprogs-1.42.12.orig/lib/ext2fs/unix_io.c 2014-08-08
15:59:39.000000000 -0500
+++ e2fsprogs-1.42.12/lib/ext2fs/unix_io.c      2015-11-07
14:31:28.209005806 -0600
@@ -887,7 +887,9 @@
 #ifndef NO_IO_CACHE
        retval = flush_cached_blocks(channel, data, 0);
 #endif
-       fsync(data->dev);
+       if (fsync(data->dev) == -1)
+               return errno;
+
        return retval;
 }


(attached)

-jason

--089e0115f052e152690523fba6e9
Content-Type: text/x-patch; charset=US-ASCII; name="filefrag.patch"
Content-Disposition: attachment; filename="filefrag.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_igppw1da0

LS0tIGUyZnNwcm9ncy0xLjQyLjEyLm9yaWcvbGliL2V4dDJmcy91bml4X2lvLmMgMjAxNC0wOC0w
OCAxNTo1OTozOS4wMDAwMDAwMDAgLTA1MDAKKysrIGUyZnNwcm9ncy0xLjQyLjEyL2xpYi9leHQy
ZnMvdW5peF9pby5jICAgICAgMjAxNS0xMS0wNyAxNDozMToyOC4yMDkwMDU4MDYgLTA2MDAKQEAg
LTg4Nyw3ICs4ODcsOSBAQAogI2lmbmRlZiBOT19JT19DQUNIRQogICAgICAgIHJldHZhbCA9IGZs
dXNoX2NhY2hlZF9ibG9ja3MoY2hhbm5lbCwgZGF0YSwgMCk7CiAjZW5kaWYKLSAgICAgICBmc3lu
YyhkYXRhLT5kZXYpOworICAgICAgIGlmIChmc3luYyhkYXRhLT5kZXYpID09IC0xKQorICAgICAg
ICAgICAgICAgcmV0dXJuIGVycm5vOworCiAgICAgICAgcmV0dXJuIHJldHZhbDsKIH0KIAo=
--089e0115f052e152690523fba6e9
Content-Type: text/x-patch; charset=US-ASCII; name="unix_io.patch"
Content-Disposition: attachment; filename="unix_io.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_igppw1ej1

LS0tIGUyZnNwcm9ncy0xLjQyLjEyLm9yaWcvbGliL2V4dDJmcy91bml4X2lvLmMgMjAxNC0wOC0w
OCAxNTo1OTozOS4wMDAwMDAwMDAgLTA1MDAKKysrIGUyZnNwcm9ncy0xLjQyLjEyL2xpYi9leHQy
ZnMvdW5peF9pby5jICAgICAgMjAxNS0xMS0wNyAxNDozMToyOC4yMDkwMDU4MDYgLTA2MDAKQEAg
LTg4Nyw3ICs4ODcsOSBAQAogI2lmbmRlZiBOT19JT19DQUNIRQogICAgICAgIHJldHZhbCA9IGZs
dXNoX2NhY2hlZF9ibG9ja3MoY2hhbm5lbCwgZGF0YSwgMCk7CiAjZW5kaWYKLSAgICAgICBmc3lu
YyhkYXRhLT5kZXYpOworICAgICAgIGlmIChmc3luYyhkYXRhLT5kZXYpID09IC0xKQorICAgICAg
ICAgICAgICAgcmV0dXJuIGVycm5vOworCiAgICAgICAgcmV0dXJuIHJldHZhbDsKIH0KIAo=
--089e0115f052e152690523fba6e9
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Libguestfs mailing list
Libguestfs@redhat.com
https://www.redhat.com/mailman/listinfo/libguestfs
--089e0115f052e152690523fba6e9--
