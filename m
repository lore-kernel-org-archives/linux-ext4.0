From: Spelic <spelic@shiftmail.org>
Subject: Ext4 and xfs problems in dm-thin on allocation and discard
Date: Mon, 18 Jun 2012 23:33:50 +0200
Message-ID: <4FDF9EBE.2030809@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8917870514997115124=="
To: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>
Return-path: <xfs-bounces@oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.

--===============8917870514997115124==
Content-type: multipart/alternative;
 boundary="Boundary_(ID_LFZuP2xNwTyTwg/PmXTa3A)"

This is a multi-part message in MIME format.

--Boundary_(ID_LFZuP2xNwTyTwg/PmXTa3A)
Content-type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7BIT

Hello all
I am doing some testing of dm-thin on kernel 3.4.2 and latest lvm from 
source (the rest is Ubuntu Precise 12.04).
There are a few problems with ext4 and (different ones with) xfs

I am doing this:
dd if=/dev/zero of=zeroes bs=1M count=1000 conv=fsync
lvs
rm zeroes #optional
dd if=/dev/zero of=zeroes bs=1M count=1000 conv=fsync  #again
lvs
rm zeroes #optional
...
dd if=/dev/zero of=zeroes bs=1M count=1000 conv=fsync  #again
lvs
rm zeroes
fstrim /mnt/mountpoint
lvs

On ext4 the problem is that it always reallocates blocks at different 
places, so you can see from lvs that space occupation in the pool and 
thinlv increases at each iteration of dd, again and again, until it has 
allocated the whole thin device (really 100% of it). And this is true 
regardless of me doing rm or not between one dd and the other.
The other problem is that by doing this, ext4 always gets the worst 
performance from thinp, about 140MB/sec on my system, because it is 
constantly allocating blocks, instead of 350MB/sec which should have 
been with my system if it used already allocated regions (see below 
compared to xfs). I am on an MD raid-5 of 5 hdds.
I could suggest to add a "thinp mode" mount option to ext4 affecting the 
allocator, so that it tries to reallocate recently used and freed areas 
and not constantly new areas. Note that mount -o discard does work and 
prevents allocation bloating, but it still always gets the worst write 
performances from thinp. Alternatively thinp could be improved so that 
block allocation is fast :-P (*)
However, good news is that fstrim works correctly on ext4, and is able 
to drop all space allocated by all dd's. Also mount -o discard works.

On xfs there is a different problem.
Xfs apparently correctly re-uses the same blocks so that after the first 
write at 140MB/sec, subsequent overwrites of the same file are at full 
speed such as 350MB/sec (same speed as with non-thin lvm), and also you 
don't see space occupation going up at every iteration of dd, either 
with or without rm in-between the dd's. [ok actually now retrying it 
needed 3 rewrites to stabilize allocation... probably an AG count thing.]
However the problem with XFS is that discard doesn't appear to work. 
Fstrim doesn't work, and neither does "mount -o discard ... + rm zeroes" 
. There is apparently no way to drop the allocated blocks, as seen from 
lvs. This is in contrast to what it is written here 
http://xfs.org/index.php/FITRIM/discard which declare fstrim and mount 
-o discard to be working.
Please note that since I am above MD raid5 (I believe this is the 
reason), the passdown of discards does not work, as my dmesg says:
[160508.497879] device-mapper: thin: Discard unsupported by data device 
(dm-1): Disabling discard passdown.
but AFAIU, unless there is a thinp bug, this should not affect the 
unmapping of thin blocks by fstrimming xfs... and in fact ext4 is able 
to do that.

(*) Strange thing is that write performance appears to be roughly the 
same for default thin chunksize and for 1MB thin chunksize. I would have 
expected thinp allocation to be faster with larger thin chunksizes but 
instead it is actually slower (note that there are no snapshots here and 
hence no CoW). This is also true if I set the thinpool to not zero newly 
allocated blocks: performances are about 240 MB/sec then, but again they 
don't increase with larger chunksizes, they actually decrease slightly 
with very large chunksizes such as 16MB. Why is that?

Thanks for your help
S.

--Boundary_(ID_LFZuP2xNwTyTwg/PmXTa3A)
Content-type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by oss.sgi.com id q5ILXgsG243846

<html>
  <head>
    <meta http-equiv=3D"content-type" content=3D"text/html; charset=3DUTF=
-8">
  </head>
  <body bgcolor=3D"#FFFFFF" text=3D"#000000">
    Hello all<br>
    I am doing some testing of dm-thin on kernel 3.4.2 and latest lvm
    from source (the rest is Ubuntu Precise 12.04).<br>
    There are a few problems with ext4 and (different ones with) xfs<br>
    <br>
    I am doing this:<br>
    dd if=3D/dev/zero of=3Dzeroes bs=3D1M count=3D1000 conv=3Dfsync<br>
    lvs<br>
    rm zeroes #optional<br>
    dd if=3D/dev/zero of=3Dzeroes bs=3D1M count=3D1000 conv=3Dfsync=C2=A0=
 #again<br>
    lvs<br>
    rm zeroes #optional<br>
    ...<br>
    dd if=3D/dev/zero of=3Dzeroes bs=3D1M count=3D1000 conv=3Dfsync=C2=A0=
 #again<br>
    lvs<br>
    rm zeroes<br>
    fstrim /mnt/mountpoint<br>
    lvs<br>
    <br>
    On ext4 the problem is that it always reallocates blocks at
    different places, so you can see from lvs that space occupation in
    the pool and thinlv increases at each iteration of dd, again and
    again, until it has allocated the whole thin device (really 100% of
    it). And this is true regardless of me doing rm or not between one
    dd and the other.<br>
    The other problem is that by doing this, ext4 always gets the worst
    performance from thinp, about 140MB/sec on my system, because it is
    constantly allocating blocks, instead of 350MB/sec which should have
    been with my system if it used already allocated regions (see below
    compared to xfs). I am on an MD raid-5 of 5 hdds.<br>
    I could suggest to add a "thinp mode" mount option to ext4 affecting
    the allocator, so that it tries to reallocate recently used and
    freed areas and not constantly new areas. Note that mount -o discard
    does work and prevents allocation bloating, but it still always gets
    the worst write performances from thinp. Alternatively thinp could
    be improved so that block allocation is fast :-P (*) <br>
    However, good news is that fstrim works correctly on ext4, and is
    able to drop all space allocated by all dd's. Also mount -o discard
    works.<br>
    <br>
    On xfs there is a different problem.<br>
    Xfs apparently correctly re-uses the same blocks so that after the
    first write at 140MB/sec, subsequent overwrites of the same file are
    at full speed such as 350MB/sec (same speed as with non-thin lvm),
    and also you don't see space occupation going up at every iteration
    of dd, either with or without rm in-between the dd's. [ok actually
    now retrying it needed 3 rewrites to stabilize allocation...
    probably an AG count thing.]<br>
    However the problem with XFS is that discard doesn't appear to work.
    Fstrim doesn't work, and neither does "mount -o discard ... + rm
    zeroes" . There is apparently no way to drop the allocated blocks,
    as seen from lvs. This is in contrast to what it is written here
    <meta http-equiv=3D"content-type" content=3D"text/html; charset=3DUTF=
-8">
    <a href=3D"http://xfs.org/index.php/FITRIM/discard">http://xfs.org/in=
dex.php/FITRIM/discard</a>
    which declare fstrim and mount -o discard to be working.<br>
    Please note that since I am above MD raid5 (I believe this is the
    reason), the passdown of discards does not work, as my dmesg says:<br=
>
    [160508.497879] device-mapper: thin: Discard unsupported by data
    device (dm-1): Disabling discard passdown.<br>
    but AFAIU, unless there is a thinp bug, this should not affect the
    unmapping of thin blocks by fstrimming xfs... and in fact ext4 is
    able to do that.<br>
    <br>
    (*) Strange thing is that write performance appears to be roughly
    the same for default thin chunksize and for 1MB thin chunksize. I
    would have expected thinp allocation to be faster with larger thin
    chunksizes but instead it is actually slower (note that there are no
    snapshots here and hence no CoW). This is also true if I set the
    thinpool to not zero newly allocated blocks: performances are about
    240 MB/sec then, but again they don't increase with larger
    chunksizes, they actually decrease slightly with very large
    chunksizes such as 16MB. Why is that?<br>
    <br>
    Thanks for your help<br>
    S.<br>
  </body>
</html>

--Boundary_(ID_LFZuP2xNwTyTwg/PmXTa3A)--


--===============8917870514997115124==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8917870514997115124==--
