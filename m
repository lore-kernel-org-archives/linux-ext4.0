From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fwd: Kernel 3.0.0 + ext4 + ceph == ...
Date: Tue, 15 Nov 2011 09:46:44 -0600
Message-ID: <4EC28964.7060200@redhat.com>
References: <4E33D101.1050504@ufm.su> <CAO47_-_EC4s1HF1pOGNzPRitYGyigOd1hfgz1qDPy6dqwGMMQA@mail.gmail.com> <CAO47_--yVuodQhMXknd2cEPpd-QkowVPV_D0+u4LM302r6SKFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, ceph-devel@vger.kernel.org
To: chb@muc.de
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CAO47_--yVuodQhMXknd2cEPpd-QkowVPV_D0+u4LM302r6SKFw@mail.gmail.com>
Sender: ceph-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 7/30/11 9:53 AM, Christian Brunner wrote:
> Fyodor and I are struggling to get a fully stable ceph cluster up and running.
> 
> When we run an Ceph-Objectstore (OSD) ontop of an ext4 filesystem, we
> get fsck errors, when we check the filesystem (see below).

BTW, this should be fixed now as of my commit 6d6a435190bdf2e04c9465cde5bdc3ac68cf11a4
ext4: fix race in xattr block allocation path

I think it made its way to a couple older -stable kernels, too.

- -Eric


> Fyodor is running 3.0.
> I am running a RHEL6.1 Kernel (2.6.32-131.6.1.el6.x86_64).
> 
> Any help or hints on how to trace the bug would be appreciated.
> 
> Thanks,
> Christian
> 
> 2011/7/30 Fyodor Ustinov <ufm@ufm.su>:
>> fail. Epic fail.
>>
>> Absolutely reproducible.
>>
>> I have ceph cluster with this configuration:
>>
>> 8 physical servers
>> 14 osd servers.
>> Each osd server have personal fs.
>> 48T total size of ceph cluster.
>> 17T used.
>>
>> Now, step by step:
>>
>> 1. Stop ceph server osd0
>> /etc/init.d/ceph stop
>>
>> 2. Make fresh fs for osd
>> umount /osd.0
>> mkfs.ext4 /dev/sdc1
>> tune2fs -o journal_data_writeback /dev/sdc1
>> mount -a
>> # string from /etc/fstab:
>> # /dev/sdc1 /osd.0          ext4
>>  user_xattr,rw,noexec,nodev,noatime,nodiratime,data=writeback,barrier=0
>>    0       2
>> ceph mon getmap -o /tmp/monmap
>> cosd --mkfs -i 0 --monmap /tmp/monmap
>>
>> 3. Start ceph server osd0
>> /etc/init.d/ceph start
>>
>> Now, make a big cup of coffee and begin to wait.
>>
>> After completion of rebalancing do:
>> /etc/init.d/ceph stop
>> umount /osd.0
>> fsck.ext4 -fy /dev/sdc1
>>
>> and see many-many messages like:
>>
>> Inode 238551053, i_blocks is 24, should be 32.  Fix? yes
>>
>> Inode 238551054, i_blocks is 40, should be 32.  Fix? yes
>>
>> Inode 238551066, i_blocks is 24, should be 32.  Fix? yes
>>
>> Inode 238944257, i_blocks is 8, should be 16.  Fix? yes
>>
>> Inode 239206414, i_blocks is 8, should be 16.  Fix? yes
>>
>> Inode 239206416, i_blocks is 40, should be 32.  Fix? yes
>>
>> Inode 239206431, i_blocks is 8, should be 16.  Fix? yes
>>
>> Inode 239206441, i_blocks is 24, should be 32.  Fix? yes
>>
>> Voila.
>>
>> P.S. No any message in syslog. No any message in console.
>>
>> WBR,
>>    Fyodor.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOwoljAAoJECCuFpLhPd7gjxIQAJ7B+f7EYxBZ+48gUrncmB5r
Izkkv2ACza+27g/CUi9ku9j1o3pjZwLNhzo3Fj0gwweB3WaY9T+JMXnfInSFegeR
GCT/8XQqGWFVoRQKKc4wUBKGgW5f+3HTgYLqUY0Z38MqMHpIMXYswXdOSB1Wc4MC
p+jEjHmTWftklpIjv+Vm61AejpoUO93SFE5gUuBeKSZxwjifV1uTUXtaZCQXUG5N
EFz+sS7YvGrttAldK+lbiq7sa7IKINnB5lbDs5ChSZoytSF9hPIRgDOTLrkAZ+k8
YovLWbu2gwGMcZEhu3ZLJ7NdtZbn45A/fh/grNU8nezTo0cTHBTYZCLqtjsUDuMr
mwUIDNUEAv6LIz0OyeJMftDX4TzxjQyEQOgYg5wyCKCjE2Nyktyap2T5sAFKamJJ
pgTUt0JSpXgDnDBL7Y3M6RbY8DQsDHIir3A7aOwdINGKweNiJXBYC3LWYHIXY0bd
yoKXT6e/Bentlj+Peugg51bw91JtlqxJT4qJfk6HMF00uxrfWHlvzht7Lu61YxrW
LBQgNyQ+Gu1drHIHyIFu95UePhzEGQcLXB3YUe7BKFGe4Vde8Jcrwn1RSFmILU6H
o9jPncZVanQYy9URQqnrcHzqpRfViuVeyhuAUh3lPt4Q7jIrr+2Ug6xWxIkBrtTt
/iKT0p8+aR3HhakrGqp4
=VbZG
-----END PGP SIGNATURE-----
